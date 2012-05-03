#
# str2saltedsha1.rb
#

module Puppet::Parser::Functions
  newfunction(:str2saltedsha1, :type => :rvalue, :doc => <<-EOS
This converts a string to a salted-SHA1 password hash (which is used for
OS X versions <= 10.6). Given any simple string, you will get a hex version
of a padded salted-SHA1 password hash that can be inserted into your Puppet
manifests as a valid password attribute.
    EOS
  ) do |arguments|
    require 'digest/sha1'
    raise(Puppet::ParseError, "str2saltedsha1(): Wrong number of arguments " +
      "passed (#{arguments.size} but we require 1)") if arguments.size != 1

    password = arguments[0]

    unless password.is_a?(String)
      raise(Puppet::ParseError, 'str2saltedsha1(): Requires a ' +
        "String argument, you passed: #{password.class}")
    end

   srand;
    seedint = rand(2**31 - 1)
    salt_hex = seedint.to_s(16)
    ('0' * 168) + salt_hex + Digest::SHA1.hexdigest([salt_hex].pack("H*") + password) + ('0' * 1024)
  end
end

# vim: set ts=2 sw=2 et :
