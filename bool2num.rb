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

    if not [FalseClass, String, TrueClass].include?(klass)
      raise(Puppet::ParseError, 'bool2num(): Requires either an ' +
        'boolean or string to work with')
    end

    if value.is_a?(String)

      result = case value
        #
        # This is how undef looks like in Puppet ...
        # We yield 0 (or false if you wish) in this case.
        #
        when /^$/, '' then 0
        when /^(1|t|y|true|yes)$/ then 1
        when /^(0|f|n|false|no)$/ then 0
        # This is not likely to happen ...
        when /^(undef|undefined)$/ then 0
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
