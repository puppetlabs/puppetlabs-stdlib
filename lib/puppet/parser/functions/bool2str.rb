#
# bool2str.rb
#

module Puppet::Parser::Functions
  newfunction(:bool2str, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Converts a boolean to a string.
    Requires a single boolean as an input.
    EOS
  ) do |arguments|

    value = arguments[0]
    klass = value.class

    # We can have either true or false, and nothing else
    unless [FalseClass, TrueClass].include?(klass)
      raise(Puppet::ParseError, 'bool2str(): Requires a boolean to work with')
    end

    return value.to_s
  end
end

# vim: set ts=2 sw=2 et :
