#
# bool2num.rb
#

module Puppet::Parser::Functions
  newfunction(:bool2num, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "bool2num(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]
    klass = value.class

    # We can have either true or false, or string which resembles boolean ...
    unless [FalseClass, TrueClass, String].include?(klass)
      raise(Puppet::ParseError, 'bool2num(): Requires either ' +
        'boolean or string to work with')
    end

    if value.is_a?(String)

      # We consider all the yes, no, y, n and so on too ...
      result = case value
        #
        # This is how undef looks like in Puppet ...
        # We yield 0 (or false if you wish) in this case.
        #
        when /^$/, '' then 0 # Empty string will be false ...
        when /^(1|t|y|true|yes)$/  then 1
        when /^(0|f|n|false|no)$/  then 0
        when /^(undef|undefined)$/ then 0 # This is not likely to happen ...
        else
          raise(Puppet::ParseError, 'bool2num(): Unknown type of boolean given')
      end

    else
      # We have real boolean values as well ...
      result = value ? 1 : 0
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
