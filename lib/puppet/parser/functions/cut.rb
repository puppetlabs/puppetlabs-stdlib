#
# cut.rb
#
module Puppet::Parser::Functions
  newfunction(:cut, :type => :rvalue, :doc => <<-EOS
Function for cutting of variables
Example:
$var = "Hello World"
$var_new = cut($var,'0','2')
notify {$var_new:}
output: He
    EOS
  ) do |arguments|

    if arguments.size != 3
    raise(Puppet::ParseError, "cut(): Wrong number of arguments " +
      "given (#{arguments.size} for 3)")
    end

    resize = arguments[0]
    start = arguments[1]
    stop = arguments[2]

    # Check that the first parameter is an array
    unless resize.is_a?(String)
       raise(Puppet::ParseError, "cut(): Requires string for arguments to work with" + " given #{resize}")
    end

    result = resize[start.to_i, stop.to_i]

    return result
  end
end

# vim: set ts=2 sw=2 et 
