#
# is_integer.rb
#

module Puppet::Parser::Functions
  newfunction(:is_integer, :type => :rvalue, :arity => 1, :doc => <<-EOS
Returns true if the variable returned to this string is an integer.
    EOS
  ) do |arguments|

    value = arguments[0]

    if value != value.to_i.to_s and !value.is_a? Fixnum then
      return false
    else
      return true
    end

  end
end

# vim: set ts=2 sw=2 et :
