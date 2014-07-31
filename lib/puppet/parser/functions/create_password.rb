require 'openssl'
require 'base64'

module Puppet::Parser::Functions
  newfunction(:create_password, :type => :rvalue, :doc => <<-'ENDOFDESC'
    A simple password generator. It takes client facts in order
    to produce a "secure" password. This prevents keeping default
    passwords after an installation.
    It won't be 100% bullet-proof though you might like to know your
    default, installation password may be changed by this function,
    providing "easy" password you can compute later.

    WARNING: the provided password will NOT be as secure as a random generated will be.
    It is just in order to prevent "default install password" to stay in place.

    Usage:
    user {'root':
      ensure   => present,
      shell    => '/bin/bash',
      password => create_password('mysecretsalt'), # will derive 1000 times, password will be 28
    }
    user {'foo':
      ensure   => present,
      shell    => '/usr/bin/fish',
      password => create_password('mysecretsalt', 300), # will derive 300 times (INSECURE), password will be 28
    }

    user {'bar':
      ensure => present,
      shell  => '/bin/bash',
      password => create_password('mysecretsalt', 1200, 30), # Derive 1200 times, password will be 30 chars
    }

    Best usage should be:
    user {'best':
      ensure   => present,
      shell    => '/bin/bash',
      password => hiera('best_password', create_password('mysecretsalt')),
    }
ENDOFDESC
  ) do |args|
    
    raise Puppet::ParseError, "create_password(): Expects at least 1 argument, 3 at most, not #{args.size}" if (args.size < 1 or args.size > 3)

    raise Puppet::ParseError, "create_password(): Expects argument 1 (salt) to be a String" unless args[0].is_a? String

    digest = OpenSSL::Digest::SHA1.new

    salt = Base64.encode64(digest.digest(args[0]))[0..10]
    iteration = args[1] || 1000
    size = args[2] || 28

    raise Puppet::ParseError, "create_password(): Expects argument 2 (iteration) to be an Integer" unless iteration.is_a?(Integer)
    raise Puppet::ParseError, "create_password(): Expects argument 3 (password size) to be an Integer" unless size.is_a?(Integer)

    password = digest.digest(lookupvar('fqdn'))

    pbkdf2 = OpenSSL::PKCS5::pbkdf2_hmac_sha1(
      password,
      salt,
      iteration,
      size
    )

    Base64.encode64( pbkdf2 ).crypt("\$6\$#{salt}")
  end
end
