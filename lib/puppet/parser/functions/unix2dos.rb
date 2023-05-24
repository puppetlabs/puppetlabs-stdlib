# frozen_string_literal: true

# Custom Puppet function to convert unix to dos format
module Puppet::Parser::Functions
  newfunction(:unix2dos, type: :rvalue, arity: 1, doc: <<-DOC
    @summary
      Returns the DOS version of the given string.

    @return
      the DOS version of the given string.

    Takes a single string argument.
  DOC
  ) do |arguments|
    raise(Puppet::ParseError, 'unix2dos(): Requires string as argument') unless arguments[0].is_a?(String)

    arguments[0].gsub(%r{\r*\n}, "\r\n")
  end
end
