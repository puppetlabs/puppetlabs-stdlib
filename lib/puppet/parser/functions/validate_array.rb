module Puppet::Parser::Functions

  newfunction(:validate_array, :doc => <<-'ENDHEREDOC') do |args|
    Validate all passed values are a Array data structure
    value does not pass the check.

    Example:

    These values validate

        $my_array = [ 'one', 'two' ]
        validate_array($my_array)

    These values do NOT validate

        validate_array(true)
        validate_array('some_string')
        $undefined = undef
        validate_array($undefined)

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_array(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      unless arg.is_a?(Array)
        raise Puppet::ParseError, ("#{arg.inspect} is not an Array.  It looks to be a #{arg.class}")
      end
    end

  end

end
