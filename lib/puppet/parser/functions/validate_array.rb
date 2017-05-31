module Puppet::Parser::Functions

  newfunction(:validate_array, :doc => _(<<-'ENDHEREDOC')) do |args|
    Validate that all passed values are array data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_array = [ 'one', 'two' ]
        validate_array($my_array)

    The following values will fail, causing compilation to abort:

        validate_array(true)
        validate_array('some_string')
        $undefined = undef
        validate_array($undefined)

    ENDHEREDOC

    function_deprecation([:validate_array, _('This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Array. There is further documentation for validate_legacy function in the README.')])

    unless args.length > 0 then
      raise Puppet::ParseError, (_("validate_array(): wrong number of arguments (%{num_args}; must be > 0)") % { num_args: args.length })
    end

    args.each do |arg|
      unless arg.is_a?(Array)
        raise Puppet::ParseError, (_("%{arg_val} is not an Array.  It looks to be a %{arg_class}") % { arg_val: arg.inspect, arg_class: arg.class })
      end
    end

  end

end
