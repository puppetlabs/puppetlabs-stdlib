#
# type.rb
#

module Puppet::Parser::Functions
  newfunction(:type, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "type(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    klass = value.class

    # This should cover all the generic types present in Puppet at present ...
    unless [Array, Bignum, Fixnum, FalseClass,
            Float, Hash, String, TrueClass].include?(klass)

      raise(Puppet::ParseError, 'type(): Unknown type given')
    end

    klass = klass.to_s # Ugly ...

    #
    # We note that Integer is the parent to Bignum and Fixnum ...
    # Plus we claim name Boolean for FalseClass and TrueClass ...
    #
    result = case klass
      when /^(?:Big|Fix)num$/      then 'Integer'
      when /^(?:False|True)Class$/ then 'Boolean'
      else klass
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
