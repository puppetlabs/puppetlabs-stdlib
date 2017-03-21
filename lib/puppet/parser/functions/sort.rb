#
#  sort.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
def recursive_hash_sort(value)
  value.keys.sort.reduce({}) do |seed, key|
    seed[key] = value[key]
    if seed[key].is_a?(Hash)
      seed[key] = recursive_hash_sort(seed[key])
    end
    seed
  end
end

module Puppet::Parser::Functions
  newfunction(:sort, :type => :rvalue, :doc => <<-EOS
Sorts strings, arrays and hashes (recursively) lexically.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "sort(): Wrong number of arguments given #{arguments.size} for 1")
    end

    value = arguments[0]

    if value.is_a?(Array) then
      value.sort
    elsif value.is_a?(String) then
      value.split("").sort.join("")
    elsif value.is_a?(Hash) then
      begin
        recursive_hash_sort(value)
      rescue ArgumentError
        raise(Puppet::ParseError, "sort(): hash contains mixed key types")
      end
    end
  end
end

# vim: set ts=2 sw=2 et :
