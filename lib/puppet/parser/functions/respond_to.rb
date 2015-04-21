# Test whether a given class or resource type responds to the given parameter.
Puppet::Parser::Functions.newfunction(:respond_to,
                                      :type => :rvalue,
                                      :doc => <<-EOS
Takes a resource type, title (only if type == class), and parameter name and
returns true if that resource responds to the given parameter.

    respond_to('class', 'apt', 'always_update_apt')
    respond_to('file', 'path')
    respond_to('apt::key', 'key')
    respond_to('archive', ['checksum_type', 'checksum_file'])
EOS
) do |args|
  args = [args] unless args.is_a?(Array)
  valid_params = []

  if args[0] =~ /^(?i:class)$/
    type, title, params = args
    raise ArgumentError, 'Must specify a class name' unless title
    raise ArgumentError, 'Must specify a parameter' unless params
    resource = find_hostclass(title)
  else
    title, params = args
    type = 'resource'
    raise ArgumentError, 'Must specify a parameter' unless params
    resource = find_resource_type(title) || find_definition(title)
  end

  raise ArgumentError, "The #{title} #{type} could not be found" if resource.nil?

  params = [params] unless params.is_a?(Array)
  params.each do |param|
    valid_params << resource.valid_parameter?(param)
  end

  if valid_params.include?(false)
    return false
  else
    return true
  end
end
