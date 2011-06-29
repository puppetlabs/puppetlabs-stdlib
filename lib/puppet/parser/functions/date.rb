#
# date.rb
#

module Puppet::Parser::Functions
  newfunction(:date, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "is_valid_netmask(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    # TODO: stubbed

  end
end

# vim: set ts=2 sw=2 et :
