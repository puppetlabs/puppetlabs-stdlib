#
# abs.rb
#

module Puppet::Parser::Functions
  newfunction(:abs, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "abs(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    if value.is_a?(String)
      if value.match(/^-?(?:\d+)(?:\.\d+){1}$/)
        value = value.to_f
      elsif value.match(/^-?\d+$/)
        value = value.to_i
      else
        raise(Puppet::ParseError, 'abs(): Requires a numeric ' +
          'value to work with')
      end
    end

    result = value.abs

    return result
  end
end

# vim: set ts=2 sw=2 et :
