# frozen_string_literal: true

# Custom Puppet function to convert dos to unix format
module Puppet::Parser::Functions
  newfunction(:dos2unix, type: :rvalue, arity: 1, doc: <<-DOC
    @summary
      Returns the Unix version of the given string.

    Takes a single string argument.

    @return The retrieved version
  DOC
  ) do |arguments|
    raise(Puppet::ParseError, 'dos2unix(): Requires string as argument') unless arguments[0].is_a?(String)

    arguments[0].gsub(%r{\r\n}, "\n")
  end
end
