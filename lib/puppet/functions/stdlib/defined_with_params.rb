# frozen_string_literal: true

#  @summary
#    Takes a resource reference and an optional hash of attributes.
#
#  Returns `true` if a resource with the specified attributes has already been added
#  to the catalog, and `false` otherwise.
#
#    ```
#    user { 'dan':
#      ensure => present,
#    }
#
#    if ! stdlib::defined_with_params(User[dan], {'ensure' => 'present' }) {
#      user { 'dan': ensure => present, }
#    }
#    ```
#
#  @return [Boolean]
#    returns `true` or `false`
Puppet::Functions.create_function(:'stdlib::defined_with_params', Puppet::Functions::InternalFunction) do
  # @return [Boolean]
  #   Returns `true` if a resource has already been added
  #
  # @param reference
  #   The resource reference to check for
  # @param params
  #   The resource's attributes
  dispatch :defined_with_params do
    scope_param
    param 'Variant[String,Type[Resource]]', :reference
    param 'Variant[String[0],Hash]', :params
  end
  def defined_with_params(scope, reference, params)
    params = {} if params == ''
    ret = false

    if Puppet::Util::Package.versioncmp(Puppet.version, '4.6.0') >= 0
      # Workaround for PE-20308
      if reference.is_a?(String)
        type_name, title = Puppet::Resource.type_and_title(reference, nil)
        type = Puppet::Pops::Evaluator::Runtime3ResourceSupport.find_resource_type_or_class(scope, type_name.downcase)
      elsif reference.is_a?(Puppet::Resource)
        type = reference.type
        title = reference.title
      elsif reference.is_a?(Puppet::Pops::Types::PResourceType)
        type = reference.type_name
        title = reference.title
      else
        raise(ArgumentError, "Reference is not understood: '#{reference.class}'")
      end
      # end workaround
    else
      type = reference.to_s
      title = nil
    end

    resources = if title.nil? or title.empty?
                  scope.catalog.resources.select { |r| r.type == type }
                else
                  [scope.findresource(type, title)]
                end

    resources.compact.each do |res|
      # If you call this from within a defined type, it will find itself
      Puppet.debug res.to_s, scope.resource.to_s, scope.resource.inspect
      next if res.to_s == scope.resource.to_s

      matches = params.map do |key, value|
        # eql? avoids bugs caused by monkeypatching in puppet
        res_is_undef = res[key].eql?(:undef) || res[key].nil?
        value_is_undef = value.eql?(:undef) || value.nil?
        found_match = (res_is_undef && value_is_undef) || (res[key] == value)

        Puppet.debug("Matching resource is #{res}") if found_match

        found_match
      end
      ret = params.empty? || !matches.include?(false)

      break if ret
    end

    Puppet.debug("Resource #{reference} was not determined to be defined") unless ret

    ret
  end
end
