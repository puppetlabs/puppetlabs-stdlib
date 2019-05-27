#
# convert_base.rb
#
module Puppet::Parser::Functions
  newfunction(:convert_base, :type => :rvalue, :arity => 2, :doc => <<-'DOC') do |args|
    @summary
      Converts a given integer or base 10 string representing an integer to a
      specified base, as a string.

    @return
      converted value as a string

    @example Example usage

    convert_base(5, 2)` results in: `'101'`
    convert_base('254', '16')` results in: `'fe'`

    > *Note:*
      Since Puppet 4.5.0 this can be done with the built-in
      [`String.new`](https://puppet.com/docs/puppet/latest/function.html#integer-to-string)
      function and its many formatting options:

      `$binary_repr = String(5, '%b')` return `"101"`
      `$hex_repr = String(254, "%x")`  return `"fe"`
      `$hex_repr = String(254, "%#x")` return `"0xfe"`

      @return [String] The converted value as a String
    DOC

    raise Puppet::ParseError, 'convert_base(): First argument must be either a string or an integer' unless args[0].is_a?(Integer) || args[0].is_a?(String)
    raise Puppet::ParseError, 'convert_base(): Second argument must be either a string or an integer' unless args[1].is_a?(Integer) || args[1].is_a?(String)

    if args[0].is_a?(String)
      raise Puppet::ParseError, 'convert_base(): First argument must be an integer or a string corresponding to an integer in base 10' unless args[0] =~ %r{^[0-9]+$}
    end

    if args[1].is_a?(String)
      raise Puppet::ParseError, 'convert_base(): First argument must be an integer or a string corresponding to an integer in base 10' unless args[1] =~ %r{^[0-9]+$}
    end

    number_to_convert = args[0]
    new_base = args[1]

    number_to_convert = number_to_convert.to_i
    new_base = new_base.to_i

    raise Puppet::ParseError, 'convert_base(): base must be at least 2 and must not be greater than 36' unless new_base >= 2 && new_base <= 36

    return number_to_convert.to_s(new_base)
  end
end
