module Puppet::Parser::Functions

  newfunction(:validate_hash, :doc => _(<<-'ENDHEREDOC')) do |args|
    Validate that all passed values are hash data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_hash = { 'one' => 'two' }
        validate_hash($my_hash)

    The following values will fail, causing compilation to abort:

        validate_hash(true)
        validate_hash('some_string')
        $undefined = undef
        validate_hash($undefined)

    ENDHEREDOC

    function_deprecation([:validate_hash, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Hash. There is further documentation for validate_legacy function in the README.'])

    unless args.length > 0 then
      raise Puppet::ParseError, (_("validate_hash(): wrong number of arguments (%{num_args}; must be > 0)") % { num_args: args.length })
    end

    args.each do |arg|
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, (_("%{arg_val} is not a Hash.  It looks to be a %{arg_class}") % { arg_val: arg.inspect, arg_class: arg.class })
      end
    end

  end

end
