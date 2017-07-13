#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join_keys_to_values, :type => :rvalue, :doc => _(<<-EOS)
This function joins each key of a hash to that key's corresponding value with a
separator. Keys are cast to strings. If values are arrays, multiple keys
are added for each element. The return value is an array in
which each element is one joined key/value pair.

*Examples:*

    join_keys_to_values({'a'=>1,'b'=>2}, " is ")

Would result in: ["a is 1","b is 2"]

    join_keys_to_values({'a'=>1,'b'=>[2,3]}, " is ")

Would result in: ["a is 1","b is 2","b is 3"]
    EOS
  ) do |arguments|

    # Validate the number of arguments.
    if arguments.size != 2
      raise(Puppet::ParseError, _("join_keys_to_values(): Takes exactly two arguments, but %{num_args} given.") % { num_args: arguments.size, })
    end

    # Validate the first argument.
    hash = arguments[0]
    if not hash.is_a?(Hash)
      raise(TypeError, _("join_keys_to_values(): The first argument must be a hash, but a %{arg_class} was given.") % { arg_class: hash.class, })
    end

    # Validate the second argument.
    separator = arguments[1]
    if not separator.is_a?(String)
      raise(TypeError, _("join_keys_to_values(): The second argument must be a string, but a %{arg_class} was given.") % { arg_class: separator.class, })
    end

    # Join the keys to their values.
    hash.map do |k,v|
      if v.is_a?(Array)
        v.map { |va| String(k) + separator + String(va) }
      else
        String(k) + separator + String(v)
      end
    end.flatten

  end
end

# vim: set ts=2 sw=2 et :
