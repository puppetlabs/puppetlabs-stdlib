require 'sha1'
require 'base64'

module Puppet::Parser::Functions
    newfunction(:sha1_passwd, :type => :rvalue, :doc => <<-EOS
      Create a base64 encoded sha1 digest of the argument. This is suitable to create for example apache SHA1 passwords.
    EOS
    ) do |args|
      raise(Puppet::ParseError, "sha1_passwd(): Wrong number of arguments " +
        "given (#{args.size} for 1)") if args.size != 1

      value = args[0]

      raise(Puppet::ParseError, 'sha1_passwd(): Requires a string to work with') unless value.class == String

      "{SHA}"+Base64.encode64(Digest::SHA1.digest(value)).chomp!
    end
end
