# frozen_string_literal: true

require 'uri'
#
#  uriescape.rb
#
module Puppet::Parser::Functions
  newfunction(:uriescape, type: :rvalue, doc: <<-DOC
    @summary
      Urlencodes a string or array of strings.
      Requires either a single string or an array as an input.

    @return [String]
      a string that contains the converted value

  DOC
  ) do |arguments|
    raise(Puppet::ParseError, "uriescape(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    raise(Puppet::ParseError, 'uriescape(): Requires either array or string to work with') unless value.is_a?(Array) || value.is_a?(String)

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? URI::DEFAULT_PARSER.escape(i) : i }
             else
               URI::DEFAULT_PARSER.escape(value)
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
