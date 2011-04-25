#
# bool2num.rb
#

module Puppet::Parser::Functions
  newfunction(:bool2num, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "bool2num(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    boolean = arguments[0]

    result = case boolean
      #
      # This is how undef looks like in Puppet ...
      # We yield 0 (or false if you wish) in this case.
      #
      when /^$/, ''        then '0'
      when /^(1|t|true)$/  then '1'
      when /^(0|f|false)$/ then '0'
      # This is not likely to happen ...
      when /^(undef|undefined)$/ then '0'
      # We may get real boolean values as well ...
      when true  then '1'
      when false then '0'
      else
        raise(Puppet::ParseError, 'bool2num(): Unknown type of boolean given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
