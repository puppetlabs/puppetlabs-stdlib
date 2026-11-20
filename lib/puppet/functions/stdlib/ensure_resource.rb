# frozen_string_literal: true

#  @summary
#    Takes a resource type, title, and a list of attributes that describe a
#    resource.
#
#  user { 'dan':
#    ensure => present,
#  }
#
#  @return
#    created or recreated the passed resource with the passed type and attributes
#
#  @example Example usage
#
#    Creates the resource if it does not already exist:
#
#      stdlib::ensure_resource('user', 'dan', {'ensure' => 'present' })
#
#    If the resource already exists but does not match the specified parameters,
#    this function will attempt to recreate the resource leading to a duplicate
#    resource definition error.
#
#    An array of resources can also be passed in and each will be created with
#    the type and parameters specified if it doesn't already exist.
#
#      ensure_resource('user', ['dan','alex'], {'ensure' => 'present'})
Puppet::Functions.create_function(:'stdlib::ensure_resource') do
  # @param type
  #   The resource type to create
  # @param title
  #   The resource title or array of resource titles
  # @param params
  #   The resource parameters
  dispatch :ensure_resource do
    param 'String', :type
    param 'Variant[String,Array[String]]', :title
    param 'Hash', :params
  end
  def ensure_resource(type, title, params)
    items = [title].flatten

    items.each do |item|
      if call_function('stdlib::defined_with_params', "#{type}[#{item}]", params)
        Puppet.debug("Resource #{type}[#{item}] with params #{params} not created because it already exists")
      else
        Puppet.debug("Create new resource #{type}[#{item}] with params #{params}")
        call_function('create_resources', type.capitalize, { item => params })
      end
    end
  end
end
