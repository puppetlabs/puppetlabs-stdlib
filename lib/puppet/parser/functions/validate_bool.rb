module Puppet::Parser::Functions

  newfunction(:validate_bool, :arity => -2, :doc => <<-'ENDHEREDOC') do |args|
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

    args.each do |arg|
      unless function_is_bool([arg])
        raise Puppet::ParseError, ("#{arg.inspect} is not a boolean.  It looks to be a #{arg.class}")
      end
    end

  end

end
