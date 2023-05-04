# frozen_string_literal: true

# @summary
#   Validate that all values passed are valid email addresses.
#   Fail compilation if any value fails this check.
Puppet::Functions.create_function(:validate_email_address) do
  # @param values An e-mail address or an array of e-mail addresses to check
  #
  # @return [Undef]
  #   Fail compilation if any value fails this check.
  #
  # @example Passing examples
  #   $my_email = "waldo@gmail.com"
  #   validate_email_address($my_email)
  #   validate_email_address("bob@gmail.com", "alice@gmail.com", $my_email)
  #
  # @example Failing examples (causing compilation to abort)
  #   $some_array = [ 'bad_email@/d/efdf.com' ]
  #   validate_email_address($some_array)
  dispatch :validate_email_address do
    repeated_param 'Stdlib::Email', :values
  end

  def validate_email_address(*args)
    assert_arg_count(args)
  end

  def assert_arg_count(args)
    raise(ArgumentError, 'validate_email_address(): Wrong number of arguments need at least one') if args.empty?
  end
end
