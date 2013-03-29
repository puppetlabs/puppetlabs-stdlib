#
# num2bool.rb
#

module Puppet::Parser::Functions
  newfunction(:num2bool, :type => :rvalue, :doc => <<-EOS
This function converts a number or a string representation of a number into a
true boolean. Zero or anything non-numeric becomes false. Numbers higher then 0
become true.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "num2bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    # we need to get an Integer out of this
    begin
      number = arguments[0].to_i
    rescue NoMethodError
      raise(Puppet::ParseError, 'num2bool(): Unable to parse number: ' + $!)
    end

    # Return true for any positive number and false otherwise
    return number > 0 ? true : false
  end
end

# vim: set ts=2 sw=2 et :
