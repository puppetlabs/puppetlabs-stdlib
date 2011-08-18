module Puppet::Parser::Functions

  newfunction(:validate_re, :doc => <<-'ENDHEREDOC') do |args|
    Perform simple validation of a string against one or more regular
    expressions. The first argument of this function should be a string to
    test, and the second argument should be a stringified regular expression
    (without the // delimiters) or an array of regular expressions.  If none
    of the regular expressions match the string passed in, compilation will
    abort with a parse error.

    The following strings will validate against the regular expressions:

        validate_re('one', '^one$')
        validate_re('one', [ '^one', '^two' ])

    The following strings will fail to validate, causing compilation to abort:

        validate_re('one', [ '^two', '^three' ])

    ENDHEREDOC
    if args.length != 2 then
      raise Puppet::ParseError, ("validate_re(): wrong number of arguments (#{args.length}; must be 2)")
    end

    msg = "validate_re(): #{args[0].inspect} does not match #{args[1].inspect}"

    raise Puppet::ParseError, (msg) unless args[1].any? do |re_str|
      args[0] =~ Regexp.compile(re_str)
    end

  end

end
