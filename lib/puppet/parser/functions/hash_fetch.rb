module Puppet::Parser::Functions
 newfunction(:hash_fetch, :type => :rvalue, :doc => <<-EOS


This function is similar to a get function on a Hash object with the
exception that it works on a nested hash.

It tries to retrieve the value to the specified key. If the key does
not exist it will return the specified default value. If key is an-
array of keys then this array is used to walk through a nested hash.

If it any time a key does not exist we return the default value.
If no default value is specified then undef is used as default.

*Examples:*

    $options = {'root' => '__USER__' }
    $account_types = {'srv' => {'options' => {'root' => '/srv' } }
    
    $real_srv_options = hash_fetch($account_types, ['srv', 'options'], $options)
    $real_tst_options = hash_fetch($account_types, ['tst', 'options'], $options)

    real_srv_options = {'root' => '/srv' }
    real_tst_options = {'root' => '__USER__' }


EOS
) do |arguments|

   info "hash_fetch called"

   raise(Puppet::ParseError, "hash_fetch(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

   raise(Puppet::ParseError, "hash_fetch(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size > 3


   hash = arguments[0]
   key = arguments[1]
   if arguments.size == 3 then
     default = arguments[2]
   else
     default = :undef
   end

   unless hash.is_a?(Hash)
     raise(Puppet::ParseError, 'hash_fetch(): Requires array to work with as the first arugument')
   end

   if not(key.is_a?(Array) or key.is_a?(String)) then
     raise(Puppet::ParseError, 'hash_fetch(): Requires string or array to work with as the second arugument')
   end

   if key.is_a?(String)
     key = [ key ]
   end

   key.each { |k|
     info "hash_fetch checking key #{k}"
     unless hash.is_a?(Hash)
       #previous iteration did not result in a hash
       #even though the keys indicate that we want to 
       #go a level deeper.
       info "hash_fetch return default, not deep enough"
       #return default
       hash = default
       break
     end

     unless hash.has_key?(k)
       info "hash_fetch return default, key not found"
       #return default
       hash = default
       break
     end

     hash = hash.fetch(k)
   }

   info "hash_fetch return result"
   hash
  end
end
