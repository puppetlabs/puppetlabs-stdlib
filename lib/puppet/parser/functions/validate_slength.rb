module Puppet::Parser::Functions

  newfunction(:validate_slength, :doc => <<-'ENDHEREDOC') do |args|
    Validate that the first argument is a string (or an array of strings), and
    less/equal to than the length of the second argument. An optional third
    parameter can be given a the minimum length. It fails if the first
    argument is not a string or array of strings, and if arg 2 and arg 3 are
    not convertable to a number.

    The following values will pass:

      validate_slength("discombobulate",17)
      validate_slength(["discombobulate","moo"],17)
      validate_slength(["discombobulate","moo"],17,3)

    The following valueis will not:

      validate_slength("discombobulate",1)
      validate_slength(["discombobulate","thermometer"],5)
      validate_slength(["discombobulate","moo"],17,10)

    ENDHEREDOC

    raise Puppet::ParseError, "validate_slength(): Wrong number of arguments (#{args.length}; must be 2 or 3)" unless args.length == 2 or args.length == 3

    input, max_length, min_length = *args

    unless (input.is_a?(String) or input.is_a?(Array))
      raise Puppet::ParseError, "validate_slength(): Expected first argument to be a String or Array, got a #{input.class}"
    end

    begin
      max_length = Integer(max_length)
      raise ArgumentError if max_length <= 0
    rescue ArgumentError, TypeError
      raise Puppet::ParseError, "validate_slength(): Expected second argument to be a positive Numeric, got #{max_length}:#{max_length.class}"
    end

    if min_length
      begin
        min_length = Integer(min_length)
        raise ArgumentError if min_length < 0
    rescue ArgumentError, TypeError
        raise Puppet::ParseError, "validate_slength(): Expected third argument to be unset or a positive Numeric, got #{min_length}:#{min_length.class}"
      end
    else
      min_length = 0
    end

    if min_length > max_length
      raise Puppet::ParseError, "validate_slength(): Expected second argument to be larger than third argument"
    end

    case input
      when String
        raise Puppet::ParseError, "validate_slength(): #{input.inspect} is #{input.length} characters.  It should have been between #{min_length} and #{max_length} characters" unless input.length <= max_length and min_length <= input.length
      when Array
        input.each do |arg|
          if arg.is_a?(String)
            unless ( arg.is_a?(String) and arg.length <= max_length and min_length <= arg.length)
              raise Puppet::ParseError, "validate_slength(): #{arg.inspect} is #{arg.length} characters.  It should have been between #{min_length} and #{max_length} characters"
            end
          else
            raise Puppet::ParseError, "validate_slength(): #{arg.inspect} is not a string, it's a #{arg.class}"
          end
        end
      else
        raise Puppet::ParseError, "validate_slength(): please pass a string, or an array of strings - what you passed didn't work for me at all - #{input.class}"
    end
  end
end
