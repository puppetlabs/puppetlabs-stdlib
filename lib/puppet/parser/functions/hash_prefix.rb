module Puppet::Parser::Functions
  newfunction(:hash_prefix, :type => :rvalue, :doc => <<-EOS
This function prefixes all keys in a hash of hashes with the provided prefix.
The first argument is the hash of hashes that is needs to be modified
The second argument is a string that needs to be added to the keys.

*Examples:*

    hash_prefix({'a'=> {'c' => 2, 'd' => 1},'b'=> {'c'=> 3, 'd'=> 2, 'e' => 5}}, 'test')

Would result in: {'testa'=> {'c' => 2, 'd' => 1},'testb'=> {'c'=> 3, 'd'=> 2, 'e' => 5}}

    EOS
  ) do |args|

    hash_to_prefix = args[0]
    prefix = args[1].to_s

    prefixed_hash = Hash[hash_to_prefix.map {|k, v| [prefix + k.to_s, v] }]

    return prefixed_hash

  end # newfunction
end # module
