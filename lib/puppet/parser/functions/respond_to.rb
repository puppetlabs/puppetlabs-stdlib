# Test whether a given class or resource type responds to the given parameter.
Puppet::Parser::Functions.newfunction(:respond_to,
                                      :type => :rvalue,
                                      :doc => <<-EOS
Takes a resource type, title (only if type == class), and parameter name and
returns true if that resource responds to the given parameter.

    respond_to('class', 'apt', 'always_update_apt')
    respond_to('file', 'path')
    respond_to('apt::key', 'key')
EOS
) do |args|
  args = [args] unless args.is_a?(Array)

  if args[0] =~ /^(?i:class)$/
    type, title, param = args
    raise ArgumentError, 'Must specify a class name' unless title
    raise ArgumentError, 'Must specify a parameter' unless param
    resource = find_hostclass(title)
  else
    title, param = args
    type = 'resource'
    raise ArgumentError, 'Must specify a parameter' unless param
    resource = find_resource_type(title) || find_definition(title)
  end

  raise ArgumentError, "The #{title} #{type} could not be found" if resource.nil?

  resource.valid_parameter?(param)
end
