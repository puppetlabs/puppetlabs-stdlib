#
# squeeze.rb
#

module Puppet::Parser::Functions
  newfunction(:squeeze, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "squeeze(): Wrong number of arguments "+
        "given #{arguments.size} for 2")
    end

  end
end

# vim: set ts=2 sw=2 et :
