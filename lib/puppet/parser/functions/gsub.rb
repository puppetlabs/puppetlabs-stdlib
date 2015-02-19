#
#  gsub.rb
#

module Puppet::Parser::Functions
  newfunction(:gsub, :type => :rvalue, :doc => <<-EOS
This function will gsub (global substituation) a given string.

It takes 3 arguments: the string to change, the regex to capture and
the string to replace the regex with.

*Examples:*

    gsub("Foo123",'[0-9]+',"ZZZ")

Would return:

    'FooZZZ'
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "gsub(): Wrong number of arguments " +
      "given (#{arguments.size} for 3)") if arguments.size < 3

    string_to_gsub = arguments[0]

    replacement_string = arguments[2]

    raise(Puppet::ParseError, 'gsub(): Requires a string for the first argument') unless string_to_gsub.class == String

    begin
      pattern = Regexp.new(arguments[1])
    rescue RegexpError => e
      raise(Puppet::ParseError, "gsub(): Regex given was incorrect: #{e}")
    end

    raise(Puppet::ParseError, 'gsub(): Requires a string for the last argument') unless replacement_string.class == String

    result = string_to_gsub.gsub!(pattern,replacement_string)

    return result
  end
end

# vim: set ts=2 sw=2 et :
