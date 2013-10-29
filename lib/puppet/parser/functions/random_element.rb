#
# random_element.rb
#
module Puppet::Parser::Functions
  newfunction(:random_element, :type => :rvalue, :doc => <<-EOS
Returns a random element from an array. Uses rand(length) rather than use
choice or sample so supports all versions of ruby

*Examples:*

  random_element(['London', 'Paris', 'New York', 'Barnsley'])

Will return a random element from this E.G:

  'Barnsley'

  EOS
  ) do | arguments|
    # We support more than one argument but at least one is mandatory ...
    raise Puppet::ParseError, "random_element(): Wrong number of " +
      "arguments given (#{arguments.size} for 1)" if arguments.size != 1
    raise TypeError, "random_element(): I need an array" unless arguments[0].is_a? Array

    array = arguments[0]
    array[rand(array.length)]

  end
end
