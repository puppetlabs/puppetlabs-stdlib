#
# sort.rb
#

module Puppet::Parser::Functions
  newfunction(:sort, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 0) then
      raise(Puppet::ParseError, "sort(): Wrong number of arguments "+
        "given #{arguments.size} for 0")
    end

  end
end

# vim: set ts=2 sw=2 et :
