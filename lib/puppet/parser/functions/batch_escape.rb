# frozen_string_literal: true

#
# batch_escape.rb
#
module Puppet::Parser::Functions
  newfunction(:batch_escape, type: :rvalue, doc: <<-DOC
    @summary
      Escapes a string so that it can be safely used in a batch shell command line.

    @return
      A string of characters with special characters converted to their escaped form.

    >* Note:* that the resulting string should be used unquoted and is not intended for use in double quotes nor in single
    quotes.
  DOC
  ) do |arguments|
    raise(Puppet::ParseError, "batch_escape(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.size != 1

    string = arguments[0].to_s

    result = ''

    string.chars.each do |char|
      result += case char
                when '"' then '""'
                when '$', '\\' then "\\#{char}"
                else char
                end
    end

    return %("#{result}")
  end
end

# vim: set ts=2 sw=2 et :
