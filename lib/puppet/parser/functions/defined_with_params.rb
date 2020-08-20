# Test whether a given class or definition is defined
require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:defined_with_params,
                                      :type => :rvalue,
                                      :doc => <<-DOC
    @summary
      Takes a resource reference and an optional hash of attributes.

    Returns `true` if a resource with the specified attributes has already been added
    to the catalog, and `false` otherwise.

      ```
      user { 'dan':
        ensure => present,
      }

      if ! defined_with_params(User[dan], {'ensure' => 'present' }) {
        user { 'dan': ensure => present, }
      }
      ```

    @return [Boolean]
      returns `true` or `false`
DOC
                                     ) do |vals|
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

  resources = if title.empty?
                catalog.resources.select { |r| r.type == type }
              else
                [findresource(type, title)]
              end

  resources.compact.each do |res|
    # If you call this from within a defined type, it will find itself
    next if res.to_s == resource.to_s

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
