# frozen_string_literal: true

# @summary
#   This converts a string to a hash with the following structure:
#
#   {
#     'type'  => "resource type",
#     'title' => "resource title",
#   }
#
#   This attempts to convert a string like 'File[/foo]' into
#   { 'type' => 'File', 'title' => '/foo', }
#
#   Things like 'File[/foo, /bar]' are not supported as a
#   title might contain things like ',' or ' '.  There is
#   no clear value seperator to use.
#
Puppet::Functions.create_function(:'stdlib::str2resource_attrib') do
  # @param res_string The string to expand like a resource
  # @example
  #   stdlib::str2resource_attrib('File[/foo]') => { 'type' => 'File', 'title' => '/foo', }
  # @return Puppet::Resource
  dispatch :str2resource_attrib do
    param 'String', :res_string
    return_type 'Hash'
  end

  def str2resource_attrib(res_string)
    type_name, title = Puppet::Resource.type_and_title(res_string, nil)

    { 'type' => type_name, 'title' => title }
  end
end
