#
# random.rb
#

module Puppet::Parser::Functions
  newfunction(:random, :type => :rvalue, :doc => <<-EOS
When given an integer x, it will choose a random float
between 0 and x. If given a range as 'x..y', it will
return a float between x and y.

*Examples:*

    random('10')

Will return: one of [0,1,2,3,4,5,6,7,8,9]

    random('1..10')

Will return: one of [1,2,3,4,5,6,7,8,9]
    EOS
) do |args|
  raise(Puppet::ParseError, "random(): Wrong number of " +
    "arguments given (#{args.size} for 1)") if args.size < 1
  last = args[0] if args.size > 1 
  rand(last)
  end
end
