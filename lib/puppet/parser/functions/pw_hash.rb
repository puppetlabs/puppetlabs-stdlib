# frozen_string_literal: true

#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible.
#  To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
Puppet::Parser::Functions.newfunction(:pw_hash, type: :rvalue, arity: 3, doc: <<-DOC
  @summary
    Hashes a password using the crypt function. Provides a hash usable
    on most POSIX systems.

  The first argument to this function is the password to hash. If it is
  undef or an empty string, this function returns undef.

  The second argument to this function is which hash algorithm to use. It
  will be converted into the appropriate crypt(3) hash specifier. Valid
  hash types are:

  |Hash type|Prefix|Note                 |
  |---------|------|---------------------|
  |MD5      |1     |                     |
  |SHA-256  |5     |                     |
  |SHA-512  |6     |Recommended          |
  |bcrypt   |2b    |                     |
  |bcrypt-a |2a    |bug compatible       |
  |bcrypt-x |2x    |bug compatible       |
  |bcrypt-y |2y    |historic alias for 2b|
  |yescrypt |y     |                     |

  The third argument to this function is the salt to use.

  **bcrypt**

  For bcrypt-type hashes, the first two characters of the salt represent a
  strength parameter, with a value between 4 and 31 inclusive.

  **yescrypt**

  For yescrypt, the characters preceding the first `$` are the encoded
  parameters. The `j9T` parameter string is commonly used and corresponds to
  the "Large and slow" profile described in the yescrypt documentation.

  Unlike bcrypt salts, a yescrypt salt cannot be an arbitrary string of
  characters from the permitted alphabet. Its encoded form must represent a
  whole number of bytes; consequently, some lengths or final characters may
  be rejected by crypt(3).

  See the yescrypt PARAMETERS documentation:
  https://github.com/openwall/yescrypt/blob/main/PARAMETERS

  @return [String]
    Provides a crypt hash usable on most POSIX systems.

  > *Note:*: this uses the Puppet Server's implementation of crypt(3). If your
    environment contains several different operating systems, ensure that they
    are compatible before using this function.
DOC
) do |args|
  raise ArgumentError, "pw_hash(): wrong number of arguments (#{args.size} for 3)" if args.size != 3

  args.map! do |arg|
    if (defined? Puppet::Pops::Types::PSensitiveType::Sensitive) && (arg.is_a? Puppet::Pops::Types::PSensitiveType::Sensitive)
      arg.unwrap
    else
      arg
    end
  end

  hashes = {
    'md5' => { prefix: '1' },
    'sha-256' => { prefix: '5' },
    'sha-512' => { prefix: '6' },
    'bcrypt' => { prefix: '2b', salt: %r{^(0[4-9]|[12][0-9]|3[01])\$[./A-Za-z0-9]{22}} },
    'bcrypt-a' => { prefix: '2a', salt: %r{^(0[4-9]|[12][0-9]|3[01])\$[./A-Za-z0-9]{22}} },
    'bcrypt-x' => { prefix: '2x', salt: %r{^(0[4-9]|[12][0-9]|3[01])\$[./A-Za-z0-9]{22}} },
    'bcrypt-y' => { prefix: '2y', salt: %r{^(0[4-9]|[12][0-9]|3[01])\$[./A-Za-z0-9]{22}} },
    'yescrypt' => { prefix: 'y', salt: %r{^[./A-Za-z0-9]+\$[./A-Za-z0-9]{0,86}} }
  }

  raise ArgumentError, 'pw_hash(): first argument must be a string' unless args[0].is_a?(String) || args[0].nil?
  raise ArgumentError, 'pw_hash(): second argument must be a string' unless args[1].is_a? String

  hash_type = hashes[args[1].downcase]
  raise ArgumentError, "pw_hash(): #{args[1]} is not a valid hash type" if hash_type.nil?
  raise ArgumentError, 'pw_hash(): third argument must be a string' unless args[2].is_a? String
  raise ArgumentError, 'pw_hash(): third argument must not be empty' if args[2].empty?

  salt_doc = hash_type.include?(:salt) ? "match #{hash_type[:salt]}" : 'be in the set [a-zA-Z0-9./]'
  salt_regex = hash_type.fetch(:salt, %r{\A[a-zA-Z0-9./]+\z})
  raise ArgumentError, "pw_hash(): characters in salt must #{salt_doc}" unless salt_regex.match?(args[2])

  password = args[0]
  return nil if password.nil? || password.empty?

  salt = "$#{hash_type[:prefix]}$#{args[2]}"

  if RUBY_PLATFORM == 'java' && !['bcrypt', 'bcrypt-a', 'bcrypt-x', 'bcrypt-y', 'yescrypt'].include?(args[1].downcase)
    # puppetserver bundles Apache Commons Codec
    org.apache.commons.codec.digest.Crypt.crypt(password.to_java_bytes, salt)
  else
    # Check the requested algorithm itself rather than probing MD5: a crypt(3)
    # can support bcrypt or SHA-512 without MD5. Weak implementations (MS Windows,
    # JRuby < 1.7.17, DES-only crypt) ignore the "$id$" prefix and return a
    # traditional DES hash, and some return NULL (Errno::EINVAL) for an unknown id.
    begin
      result = password.crypt(salt)
    rescue Errno::EINVAL
      result = nil
    end

    unless result&.start_with?("$#{hash_type[:prefix]}$")
      if args[1].casecmp('yescrypt').zero?
        begin
          yescrypt_probe = ''.crypt('$y$j9T$')
        rescue Errno::EINVAL
          yescrypt_probe = nil
        end
        raise Puppet::ParseError, 'system does not support enhanced salts' if yescrypt_probe.nil?
        raise ArgumentError, 'pw_hash(): invalid yescrypt parameters or salt'
      end

      raise Puppet::ParseError, 'system does not support enhanced salts'
    end

    result
  end
end
