#
# filter_hash.rb
#

module Puppet::Parser::Functions
  newfunction(:filter_hash_of_hash, :type => :rvalue, :doc => <<-EOS
This function filters an hash of hashes.
The first argument is the hash of hashes that is filtered.
The second argument is an hash and servers as the criteria.

The criteria hash is matched on the values of the first argument. A criteria matches if all key/value pairs are present. If the value of a key is undef the key should not be present in the searched hash.

*Examples:*

    filter_hash_of_hash({'a'=> {'c' => 2, 'd' => 1},'b'=> {'c'=> 2, 'd'=> 2}}, {'c' => 2})

Would result in: {'a'=> {'c' => 2, 'd' => 1},'b'=> {'c'=> 2, 'd'=> 2}}

    filter_hash_of_hash({'a'=> {'c' => 2, 'd' => 1},'b'=> {'c'=> 2, 'd'=> 2}}, {'c' => 2, 'd' => 1})

Would result in: {'a'=> {'c' => 2, 'd' => 1}}
    EOS
  ) do |arguments|

    # Validate the number of arguments.
    if arguments.size != 2
      raise(Puppet::ParseError, "filter_hash_of_hash(): Takes exactly two " +
            "arguments, but #{arguments.size} given.")
    end

    # Validate the first argument.
    hash = arguments[0]
    if not hash.is_a?(Hash)
      raise(TypeError, "filter_hash_of_hash(): The first argument must be a " +
            "hash, but a #{hash.class} was given.")
    end

    # Validate the second argument.
    hash_match = arguments[1]
    if not hash_match.is_a?(Hash)
      raise(TypeError, "filter_hash_of_hash(): The second argument must be a " +
            "Hash, but a #{hash_match.class} was given.")
    end

    hash_copy = hash.dup

    hash_copy.delete_if do |k,v|
      hash_match.all? do |key, val|
        if val == :undef
          #check if the key does not exist
          v.has_key?(key)
        else
          !( v.has_key?(key) and v[key] == val )
        end
      end
    end
    hash_copy
  end
end

# vim: set ts=2 sw=2 et :
