# frozen_string_literal: true

#  @summary
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
#    stdlib::ensure_resources('user', {'dan' => { gid => 'mygroup', uid => '600' }, 'alex' => { gid => 'mygroup' }}, {'ensure' => 'present'})
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
Puppet::Functions.create_function(:'stdlib::ensure_resources') do
  # @param type
  #   The resource type to create
  # @param titles
  #   A hash of resource titles mapping to resource parameters
  # @param params
  #  A hash of default parameters to be merged with individual resource parameters
  dispatch :ensure_resources do
    param          'String', :type
    param          'Hash[String,Hash]', :titles
    optional_param 'Hash', :params
  end
  def ensure_resources(type, titles, params)
    resource_hash = titles.dup
    resources = resource_hash.keys

    resources.each do |resource_name|
      params_merged = if resource_hash[resource_name]
                        params.merge(resource_hash[resource_name])
                      else
                        params
                      end
      call_function('stdlib::ensure_resource', type, resource_name, params_merged)
    end
  end
end
