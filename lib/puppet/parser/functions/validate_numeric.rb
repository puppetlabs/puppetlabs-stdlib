module Puppet::Parser::Functions

  newfunction(:validate_numeric, :doc => _(<<-'ENDHEREDOC')) do |args|
    Validate that the first argument is a numeric value (or an array of numeric values). Abort catalog compilation if any of the checks fail.

    The second argument is optional and passes a maximum. (All elements of) the first argument has to be less or equal to this max.

    The third argument is optional and passes a minimum.  (All elements of) the first argument has to be greater or equal to this min.
    If, and only if, a minimum is given, the second argument may be an empty string or undef, which will be handled to just check
    if (all elements of) the first argument are greater or equal to the given minimum.

    It will fail if the first argument is not a numeric (Integer or Float) or array of numerics, and if arg 2 and arg 3 are not convertable to a numeric.

    For passing and failing usage, see `validate_integer()`. It is all the same for validate_numeric, yet now floating point values are allowed, too.

    ENDHEREDOC

    function_deprecation([:validate_numeric, 'This method is deprecated, please use the stdlib validate_legacy function, with Stdlib::Compat::Numeric. There is further documentation for validate_legacy function in the README.'])

    # tell the user we need at least one, and optionally up to two other parameters
    raise Puppet::ParseError, _("validate_numeric(): Wrong number of arguments; must be 1, 2 or 3, got %{num_args}") % { num_args: args.length } unless args.length > 0 and args.length < 4

    input, max, min = *args

    # check maximum parameter
    if args.length > 1
      max = max.to_s
      # allow max to be empty (or undefined) if we have a minimum set
      if args.length > 2 and max == ''
        max = nil
      else
        begin
          max = Float(max)
        rescue TypeError, ArgumentError
          raise Puppet::ParseError, _("validate_numeric(): Expected second argument to be unset or a Numeric, got %{max}:%{max_class}") % { max: max, max_class: max.class }
        end
      end
    else
      max = nil
    end

    # check minimum parameter
    if args.length > 2
      begin
        min = Float(min.to_s)
      rescue TypeError, ArgumentError
        raise Puppet::ParseError, _("validate_numeric(): Expected third argument to be unset or a Numeric, got %{min}:%{min_class}") % { min: min, min_class: min.class, }
      end
    else
      min = nil
    end

    # ensure that min < max
    if min and max and min > max
      raise Puppet::ParseError, _("validate_numeric(): Expected second argument to be larger than third argument, got %{max} < %{min}") % { max: max, min: min, }
    end

    # create lamba validator function
    validator = lambda do |num|
      # check input < max
      if max and num > max
        raise Puppet::ParseError, _("validate_numeric(): Expected %{val} to be smaller or equal to %{max}, got %{val}.") % { val: input.inspect, max: max }
      end
      # check input > min (this will only be checked if no exception has been raised before)
      if min and num < min
        raise Puppet::ParseError, _("validate_numeric(): Expected %{val} to be greater or equal to %{min}, got %{val}.") % { val: input.inspect, min: min }
      end
    end

    # if this is an array, handle it.
    case input
    when Array
      # check every element of the array
      input.each_with_index do |arg, pos|
        begin
          raise TypeError if arg.is_a?(Hash)
          arg = Float(arg.to_s)
          validator.call(arg)
        rescue TypeError, ArgumentError
          raise Puppet::ParseError, _("validate_numeric(): Expected element at array position %{pos} to be a Numeric, got %{arg_class}") % { pos: pos, arg_class: arg.class }
        end
      end
    # for the sake of compatibility with ruby 1.8, we need extra handling of hashes
    when Hash
      raise Puppet::ParseError, _("validate_integer(): Expected first argument to be a Numeric or Array, got %{arg_class}") % { arg_class: input.class }
    # check the input. this will also fail any stuff other than pure, shiny integers
    else
      begin
        input = Float(input.to_s)
        validator.call(input)
      rescue TypeError, ArgumentError
        raise Puppet::ParseError, _("validate_numeric(): Expected first argument to be a Numeric or Array, got %{arg_class}") % { arg_class: input.class }
      end
    end
  end
end
