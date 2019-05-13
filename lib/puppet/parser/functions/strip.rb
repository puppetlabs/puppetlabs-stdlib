#
#  strip.rb
#
module Puppet::Parser::Functions
  newfunction(:strip, :type => :rvalue, :doc => <<-DOC
    @summary
      This function removes leading and trailing whitespace from a string or from
      every string inside an array.

    @return
      String or Array converted

    @example **Usage**

      strip("    aaa   ")
      Would result in: "aaa"

    > *Note:*: from Puppet 6.0.0, the compatible function with the same name in Puppet core
    will be used instead of this function.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "strip(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'strip(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               value.map { |i| i.is_a?(String) ? i.strip : i }
             else
               value.strip
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
