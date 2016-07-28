# 
# hash2plist.rb
#

require 'puppet/util/plist'

module Puppet::Parser::Functions
  newfunction(:hash2plist, :type => :rvalue , :doc => <<-EOS
Takes a hash as an input and returns a plist as a string useful
for file generation and input to programs. Possilbe formats are xml
(default) and binary.
    EOS
  ) do |args|

    hash   = args[0]
    format = args[1] || :xml

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, 'hash2plist(): Requires a valid ' +
        'hash as input.')
    end

    return Puppet::Util::Plist.dump_plist(hash, format)

  end
end
