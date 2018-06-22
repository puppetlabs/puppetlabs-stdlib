#
# join_keys_to_values.rb
#
module Puppet::Parser::Functions
  newfunction(:join_keys_to_values, :type => :rvalue, :doc => <<-DOC
    This function joins each key of a hash to that key's corresponding value with a
    separator. Keys are cast to strings. If values are arrays, multiple keys
    are added for each element. The return value is an array in
    which each element is one joined key/value pair.

    *Examples:*

        join_keys_to_values({'a'=>1,'b'=>2}, " is ")

    Would result in: ["a is 1","b is 2"]

        join_keys_to_values({'a'=>1,'b'=>[2,3]}, " is ")

    Would result in: ["a is 1","b is 2","b is 3"]

    Note: Since Puppet 5.0.0 - for more detailed control over the formatting (including indentations and
    line breaks, delimiters around arrays and hash entries, between key/values in hash entries, and individual
    formatting of values in the array) - see the `new` function for `String` and its formatting
    options for `Array` and `Hash`.
    DOC
             ) do |arguments|

    # Validate the number of arguments.
    if arguments.size != 2
      raise(Puppet::ParseError, "join_keys_to_values(): Takes exactly two arguments, but #{arguments.size} given.")
    end

    # Validate the first argument.
    hash = arguments[0]
    unless hash.is_a?(Hash)
      raise(TypeError, "join_keys_to_values(): The first argument must be a hash, but a #{hash.class} was given.")
    end

    # Validate the second argument.
    separator = arguments[1]
    unless separator.is_a?(String)
      raise(TypeError, "join_keys_to_values(): The second argument must be a string, but a #{separator.class} was given.")
    end

    # Join the keys to their values.
    hash.map { |k, v|
      if v.is_a?(Array)
        v.map { |va| String(k) + separator + String(va) }
      elsif String(v) == 'undef'
        String(k)
      else
        String(k) + separator + String(v)
      end
    }.flatten
  end
end

# vim: set ts=2 sw=2 et :
