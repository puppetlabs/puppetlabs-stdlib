module Puppet::Parser::Functions

  newfunction(:validate_bool, :doc => _(<<-'ENDHEREDOC')) do |args|
    Validate that all passed values are either true or false. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $iamtrue = true
        validate_bool(true)
        validate_bool(true, true, false, $iamtrue)

    The following values will fail, causing compilation to abort:

        $some_array = [ true ]
        validate_bool("false")
        validate_bool("true")
        validate_bool($some_array)

    ENDHEREDOC

    # The deprecation function was being called twice, as validate_bool calls is_bool. I have removed it from here so it only calls deprecation once within is_bool.
    # function_deprecation([:validate_bool, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Bool. There is further documentation for validate_legacy function in the README.'])

    unless args.length > 0 then
      raise Puppet::ParseError, (_("validate_bool(): wrong number of arguments (%{num_args}; must be > 0)") % { num_args: args.length })
    end

    args.each do |arg|
      unless function_is_bool([arg])
        raise Puppet::ParseError, (_("%{arg_val} is not a boolean.  It looks to be a %{arg_class}") % { arg_val: arg.inspect, arg_class: arg.class })
      end
    end

  end

end
