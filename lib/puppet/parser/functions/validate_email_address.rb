module Puppet::Parser::Functions
  newfunction(:validate_email_address, :doc => _(<<-ENDHEREDOC)
    Validate that all values passed are valid email addresses.
    Fail compilation if any value fails this check.
    The following values will pass:
    $my_email = "waldo@gmail.com"
    validate_email_address($my_email)
    validate_email_address("bob@gmail.com", "alice@gmail.com", $my_email)

    The following values will fail, causing compilation to abort:
    $some_array = [ 'bad_email@/d/efdf.com' ]
    validate_email_address($some_array)
    ENDHEREDOC
             ) do |args|
    rescuable_exceptions = [ArgumentError]

    if args.empty?
      raise Puppet::ParseError, _("validate_email_address(): wrong number of arguments (%{num_args}; must be > 0)") % { num_args: args.length }
    end

    args.each do |arg|
      raise Puppet::ParseError, _("%{arg_val} is not a string.") % { arg_val: arg.inspect } unless arg.is_a?(String)

      begin
        raise Puppet::ParseError, _("%{arg_val} is not a valid email address") % { arg_val: arg.inspect } unless function_is_email_address([arg])
      rescue *rescuable_exceptions
        raise Puppet::ParseError, _("%{arg_val} is not a valid email address") % { arg_val: arg.inspect }
      end
    end
  end
end
