#
# num2bool.rb
#

module Puppet::Parser::Functions
  newfunction(:num2bool, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "num2bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    number = arguments[0]

    # Only numbers allowed ...
    if not number.match(/^\-?\d+$/)
      raise(Puppet::ParseError, 'num2bool(): Requires a number to work with')
    end

    result = case number
      when /^0$/
        false
      when /^\-?\d+$/
        # In Puppet numbers are often string-encoded ...
        number = number.to_i
        # We yield true for any positive number and false otherwise ...
        number > 0 ? true : false
      else
        raise(Puppet::ParseError, 'num2bool(): Unknown number format given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
