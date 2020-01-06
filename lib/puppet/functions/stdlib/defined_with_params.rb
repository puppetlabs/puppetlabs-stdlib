# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
# Test whether a given class or definition is defined
require 'puppet/parser/functions'

# ---- original file header ----
#
# @summary
#       @summary
#      Takes a resource reference and an optional hash of attributes.
#
#    Returns `true` if a resource with the specified attributes has already been added
#    to the catalog, and `false` otherwise.
#
#      ```
#      user { 'dan':
#        ensure => present,
#      }
#
#      if ! defined_with_params(User[dan], {'ensure' => 'present' }) {
#        user { 'dan': ensure => present, }
#      }
#      ```
#
#    @return [Boolean]
#      returns `true` or `false`
#
#
Puppet::Functions.create_function(:'stdlib::defined_with_params') do
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
    reference, params = vals
    raise(ArgumentError, 'Must specify a reference') unless reference
    if !params || params == ''
      params = {}
    end
    ret = false

    if Puppet::Util::Package.versioncmp(Puppet.version, '4.6.0') >= 0
      # Workaround for PE-20308
      if reference.is_a?(String)
        type_name, title = Puppet::Resource.type_and_title(reference, nil)
        type = Puppet::Pops::Evaluator::Runtime3ResourceSupport.find_resource_type_or_class(find_global_scope, type_name.downcase)
      elsif reference.is_a?(Puppet::Resource)
        type = reference.type
        title = reference.title
      else
        raise(ArgumentError, "Reference is not understood: '#{reference.class}'")
      end
      # end workaround
    else
      type = reference.to_s
      title = nil
    end

    resource = findresource(type, title)
    if resource
      matches = params.map do |key, value|
        # eql? avoids bugs caused by monkeypatching in puppet
        resource_is_undef = resource[key].eql?(:undef) || resource[key].nil?
        value_is_undef = value.eql?(:undef) || value.nil?
        (resource_is_undef && value_is_undef) || (resource[key] == value)
      end
      ret = params.empty? || !matches.include?(false)
    end
    Puppet.debug("Resource #{reference} was not determined to be defined")
    ret
  end
end
