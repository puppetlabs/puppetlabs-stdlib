# frozen_string_literal: true

# @summary
#   Validate that all values passed are syntactically correct domain names.
#   Fail compilation if any value fails this check.
Puppet::Functions.create_function(:'stdlib::validate_domain_name') do
  # @param values A domain name or an array of domain names to check
  #
  # @return [Undef]
  #   passes when the given values are syntactically correct domain names or raise an error when they are not and fails compilation
  #
  # @example Passing examples
  #   $my_domain_name = 'server.domain.tld'
  #   stdlib::validate_domain_name($my_domain_name)
  #   stdlib::validate_domain_name('domain.tld', 'puppet.com', $my_domain_name)
  #   stdlib::validate_domain_name('www.example.2com')
  #
  # @example Failing examples (causing compilation to abort)
  #   stdlib::validate_domain_name(1)
  #   stdlib::validate_domain_name(true)
  #   stdlib::validate_domain_name('invalid domain')
  #   stdlib::validate_domain_name('-foo.example.com')
  dispatch :validate_domain_name do
    repeated_param 'Variant[Stdlib::Fqdn, Stdlib::Dns::Zone]', :values
  end

  def validate_domain_name(*args)
    assert_arg_count(args)
  end

  def assert_arg_count(args)
    raise(ArgumentError, 'stdlib::validate_domain_name(): Wrong number of arguments need at least one') if args.empty?
  end
end
