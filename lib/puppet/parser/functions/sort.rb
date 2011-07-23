#
# sort.rb
#

module Puppet::Parser::Functions
  newfunction(:sort, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "sort(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    arguments[0].sort

  end
end

# vim: set ts=2 sw=2 et :
