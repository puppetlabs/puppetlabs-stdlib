# str2saltedpbkdf2.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
module Puppet::Parser::Functions
  newfunction(:str2saltedpbkdf2, :type => :rvalue, :doc => <<-DOC
    @summary Convert a string into a salted SHA512 PBKDF2 password hash like requred for OS X / macOS 10.8+

    Convert a string into a salted SHA512 PBKDF2 password hash like requred for OS X / macOS 10.8+.
    Note, however, that Apple changes what's required periodically and this may not work for the latest
    version of macOS. If that is the case you should get a helpful error message when Puppet tries to set
    the pasword using the parameters you provide to the user resource.

    @example Plain text password and salt
      $pw_info = str2saltedpbkdf2('Pa55w0rd', 'Using s0m3 s@lt', 50000)
      user { 'jdoe':
        ensure     => present,
        iterations => $pw_info['interations'],
        password   => $pw_info['password_hex'],
        salt       => $pw_info['salt_hex'],
      }

    @example Sensitive password and salt
      $pw = Sensitive.new('Pa55w0rd')
      $salt = Sensitive.new('Using s0m3 s@lt')
      $pw_info = Sensitive.new(str2saltedpbkdf2($pw, $salt, 50000))
      user { 'jdoe':
        ensure     => present,
        iterations => unwrap($pw_info)['interations'],
        password   => unwrap($pw_info)['password_hex'],
        salt       => unwrap($pw_info)['salt_hex'],
      }

    @return [Hash]
      Provides a hash containing the hex version of the password, the hex version of the salt, and iterations.
  DOC
             ) do |args|
    require 'openssl'

    raise ArgumentError, "str2saltedpbkdf2(): wrong number of arguments (#{args.size} for 3)" if args.size != 3

    args.map! do |arg|
      if (defined? Puppet::Pops::Types::PSensitiveType::Sensitive) && (arg.is_a? Puppet::Pops::Types::PSensitiveType::Sensitive)
        arg.unwrap
      else
        arg
      end
    end

    raise ArgumentError, 'str2saltedpbkdf2(): first argument must be a string' unless args[0].is_a?(String)
    raise ArgumentError, 'str2saltedpbkdf2(): second argument must be a string' unless args[1].is_a?(String)
    raise ArgumentError, 'str2saltedpbkdf2(): second argument must be at least 8 bytes long' unless args[1].bytesize >= 8
    raise ArgumentError, 'str2saltedpbkdf2(): third argument must be an integer' unless args[2].is_a?(Integer)
    raise ArgumentError, 'str2saltedpbkdf2(): third argument must be between 40,000 and 70,000' unless args[2] > 40_000 && args[2] < 70_000

    password   = args[0]
    salt       = args[1]
    iterations = args[2]
    keylen     = 128
    digest     = OpenSSL::Digest::SHA512.new
    hash       = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, iterations, keylen, digest)

    {
      'password_hex' => hash.unpack('H*').first,
      'salt_hex'     => salt.unpack('H*').first,
      'iterations'   => iterations,
    }
  end
end
