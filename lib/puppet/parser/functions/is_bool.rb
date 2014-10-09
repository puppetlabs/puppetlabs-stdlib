#
# is_bool.rb
#

module Puppet::Parser::Functions
  newfunction(:is_bool, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the variable passed to this function is a boolean.
    EOS
  ) do |arguments|

    type = arguments[0]

    result = type.is_a?(TrueClass) || type.is_a?(FalseClass)

    return result
  end
end

# vim: set ts=2 sw=2 et :
