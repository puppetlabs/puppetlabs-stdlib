#
# rand.rb
#

module Puppet::Parser::Functions
  newfunction(:rand, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 0) and (arguments.size != 1) then
      raise(Puppet::ParseError, "rand(): Wrong number of arguments "+
        "given #{arguments.size} for 0 or 1")
    end

  end
end

# vim: set ts=2 sw=2 et :
