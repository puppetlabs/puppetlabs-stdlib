#
# str2pbkdf2_hash.rb
#

module Puppet::Parser::Functions
  newfunction(:str2pbkdf2_hash, :type => :rvalue, :doc => <<-EOS
This converts a string, a salt, and an iterations value to a
salted-SHA512-PBKDF2 password hash (which is used for OS X versions > 10.7).
For more information about PBKDF2, see --> http://en.wikipedia.org/wiki/PBKDF2

Given a plaintext password string, a 32-byte salt, and an integer value for
the number of iterations the computational hash will be calcultated, you will
get a hex version of a salted-SHA512-PBKDF2 password hash that can be inserted
into your Puppet manifests as a valid password attribute in versions of OS X
greater than 10.7.  For example:

    $password_hash = str2pbkdf2_hash('password', 'saltvalue', 10000)

Because a PBKDF2 password hash is useless without knowing the value of the salt
and the iterations value, you MUST pass all three arguments in the following
format:

    plaintext password:   A String
    salt:                 A String, 32-bytes is recommended
    iterations:           An Integer, between 10000 and 15000 is recommended

Failing to pass the salt and iterations value is a ParseError
    EOS
  ) do |arguments|
    require 'openssl'

    raise(Puppet::ParseError, "str2pbkdf2_hash(): Wrong number of arguments " +
      "passed (#{arguments.size} but we require exactly 3)") \
      if arguments.size != 3

    password   = arguments[0]
    salt       = arguments[1]
    begin
      iterations = Integer(arguments[2])
    rescue ArgumentError => e
      raise(Puppet::ParseError, 'str2pbkdf2_hash(): The third argument, the ' +
                                'iterations value, could not be cast to an ' +
                                'Integer. Please pass an Integer (between ' +
                                '10000 and 15000 is recommended). ' + e.message)
    end

    unless password.is_a?(String)
      raise(Puppet::ParseError, 'str2pbkdf2_hash(): The first argument, a ' +
        'plaintext password, must be a String, ' +
        "you passed: #{password.class}")
    end

    unless salt.is_a?(String)
      raise(Puppet::ParseError, 'str2pbkdf2_hash(): The second argument, the ' +
        'password salt, must be a String (32 bytes is recommended), ' +
        "you passed: #{salt.class}")
    end

    returned_hash = ''

    # The method employed is similar to the method used in the PBKDF2 Rubygem
    # located at <https://github.com/emerose/pbkdf2-ruby/>. Remember that
    # PBKDF2 is just a method for implementing key stretching, so the iterations
    # value becomes important (as it's essentially how many times you 'spin the
    # tumblers' to calculate the hash). It's recommended to use an iterations
    # value of 10,000 or greater for added security.
    1.upto(2) do |t|
      password_hash = OpenSSL::HMAC.digest('sha512', password, (salt+[t].pack("N")))
      stored_value = password_hash
      2.upto(iterations) do
        password_hash = OpenSSL::HMAC.digest('sha512', password, password_hash)
        password_hash_ord = password_hash.unpack('C*')
        stored_value = stored_value.unpack('C*')
        stored_value = (0..stored_value.length-1).collect do |element|
          # In Ruby 1.9, stored_value[element] is a String, but in 1.8 it's
          # a Fixnum. To avoid the situation, we unpack the String so that
          # the XOR operator ( ^ ) will work just fine on 1.8 and 1.9
          stored_value[element] ^ password_hash_ord[element]
        end
        stored_value = stored_value.pack('C*')
      end
      returned_hash << stored_value
    end

    returned_hash.slice(0, 128).unpack('H*').first
  end
end

# vim: set ts=2 sw=2 et :
