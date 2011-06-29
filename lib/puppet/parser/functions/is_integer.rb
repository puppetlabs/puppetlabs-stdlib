#
# is_integer.rb
#

module Puppet::Parser::Functions
  newfunction(:is_integer, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_integer(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

  end
end

# vim: set ts=2 sw=2 et :
