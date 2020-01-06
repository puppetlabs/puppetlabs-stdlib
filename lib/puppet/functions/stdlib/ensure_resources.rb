# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
require 'puppet/parser/functions'

# ---- original file header ----
#
# @summary
#     @summary
#    Takes a resource type, title (only hash), and a list of attributes that describe a
#    resource.
#
#  @return
#    created resources with the passed type and attributes
#
#  @example Example usage
#
#        user { 'dan':
#          gid => 'mygroup',
#          ensure => present,
#        }
#
#    An hash of resources should be passed in and each will be created with
#    the type and parameters specified if it doesn't already exist.
#
#    ensure_resources('user', {'dan' => { gid => 'mygroup', uid => '600' }, 'alex' => { gid => 'mygroup' }}, {'ensure' => 'present'})
#
#    From Hiera Backend:
#
#    userlist:
#      dan:
#        gid: 'mygroup'
#     uid: '600'
#      alex:
#     gid: 'mygroup'
#
#    Call:
#    ensure_resources('user', hiera_hash('userlist'), {'ensure' => 'present'})
#
#
Puppet::Functions.create_function(:'stdlib::ensure_resources') do
  # @param vals
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :vals
  end

  def default_impl(*vals)
    type, title, params = vals
    raise(ArgumentError, 'Must specify a type') unless type
    raise(ArgumentError, 'Must specify a title') unless title
    params ||= {}

    raise(Puppet::ParseError, 'ensure_resources(): Requires second argument to be a Hash') unless title.is_a?(Hash)
    resource_hash = title.dup
    resources = resource_hash.keys

    Puppet::Parser::Functions.function(:ensure_resource)
    resources.each do |resource_name|
      params_merged = if resource_hash[resource_name]
                        params.merge(resource_hash[resource_name])
                      else
                        params
                      end
      function_ensure_resource([type, resource_name, params_merged])
    end
  end
end
