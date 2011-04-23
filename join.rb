#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    array = arguments[0]

    suffix = arguments[1]
    prefix = arguments[2]

    if prefix and not prefix.empty?
      result = prefix + array.join(suffix + prefix)
    else
      result = array.join(suffix)
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
