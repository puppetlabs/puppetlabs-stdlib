module Puppet::Parser::Functions

  newfunction(:validate_string, :doc => _(<<-'ENDHEREDOC')) do |args|
    Validate that all passed values are string data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_string = "one two"
        validate_string($my_string, 'three')

    The following values will fail, causing compilation to abort:

        validate_string(true)
        validate_string([ 'some', 'array' ])

    Note: validate_string(undef) will not fail in this version of the
    functions API (incl. current and future parser). Instead, use:

        if $var == undef {
          fail('...')
        }

    ENDHEREDOC

    function_deprecation([:validate_string, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::String. There is further documentation for validate_legacy function in the README.'])

    unless args.length > 0 then
      raise Puppet::ParseError, (_("validate_string(): wrong number of arguments (%{num_args}; must be > 0)") % { num_args: args.length })
    end

    args.each do |arg|
      # when called through the v4 API shim, undef gets translated to nil
      unless arg.is_a?(String) || arg.nil?
        raise Puppet::ParseError, (_("%{val} is not a string.  It looks to be a %{arg_class}") % { val: arg.inspect, arg_class: arg.class })
      end
    end

  end

end
