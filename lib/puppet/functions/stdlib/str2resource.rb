# frozen_string_literal: true

# @summary
#   This converts a string to a puppet resource.
#
# This attempts to convert a string like 'File[/foo]' into the
# puppet resource `File['/foo']` as detected by the catalog.
#
# Things like 'File[/foo, /bar]' are not supported as a
# title might contain things like ',' or ' '.  There is
# no clear value seperator to use.
#
# This function can depend on the parse order of your
# manifests/modules as it inspects the catalog thus far.
Puppet::Functions.create_function(:'stdlib::str2resource') do
  # @param res_string The string to lookup as a resource
  # @example
  #   stdlib::str2resource('File[/foo]') => File[/foo]
  # @return Puppet::Resource
  dispatch :str2resource do
    param 'String', :res_string
    # return_type 'Puppet::Resource'
    return_type 'Any'
  end

  def str2resource(res_string)
    type_name, title = Puppet::Resource.type_and_title(res_string, nil)

    resource = closure_scope.findresource(type_name, title)

    raise(Puppet::ParseError, "stdlib::str2resource(): could not find #{type_name}[#{title}], this is parse order dependent and values should not be quoted") if resource.nil?

    resource
  end
end
