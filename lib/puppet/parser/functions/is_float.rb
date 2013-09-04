#
# is_float.rb
#

module Puppet::Parser::Functions
  newfunction(:is_float, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the variable passed to this function is a float.
    EOS
  ) do |arguments|

    value = arguments[0]

    if value != value.to_f.to_s and !value.is_a? Float then
      return false
    else
      return true
    end

  end
end

# vim: set ts=2 sw=2 et :
