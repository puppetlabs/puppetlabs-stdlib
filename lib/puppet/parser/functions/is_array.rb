#
# is_array.rb
#

module Puppet::Parser::Functions
  newfunction(:is_array, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the variable passed to this function is an array.
    EOS
  ) do |arguments|

    type = arguments[0]

    result = type.is_a?(Array)

    return result
  end
end

# vim: set ts=2 sw=2 et :
