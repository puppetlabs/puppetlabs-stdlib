module Puppet::Parser::Functions

  newfunction(:convert_base, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|

    Converts a given integer or string representing an integer to a specified base, as a string.

    Usage:

      $binary_repr = convert_base(5, 2)  # $binary_repr is now set to "101"
      $hex_repr = convert_base("254", "16")  # $hex_repr is now set to "fe"

    ENDHEREDOC

    raise Puppet::ParseError, ("convert_base(): Wrong number of arguments (#{args.length}; must be = 2)") unless args.length == 2
    raise Puppet::ParseError, ("convert_base(): First argument must be either a string or an integer") unless (args[0].is_a?(Integer) or args[0].is_a?(String))
    raise Puppet::ParseError, ("convert_base(): Second argument must be either a string or an integer") unless (args[1].is_a?(Integer) or args[1].is_a?(String))

    number_to_convert = args[0]
    new_base = args[1]

    number_to_convert = number_to_convert.to_i()
    new_base = new_base.to_i()

    return number_to_convert.to_s(new_base)
  end
end
