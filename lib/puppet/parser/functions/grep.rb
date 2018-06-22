#
# grep.rb
#
module Puppet::Parser::Functions
  newfunction(:grep, :type => :rvalue, :doc => <<-DOC
    This function searches through an array and returns any elements that match
    the provided regular expression.

    *Examples:*

        grep(['aaa','bbb','ccc','aaaddd'], 'aaa')

    Would return:

        ['aaa','aaaddd']

    Note that since Puppet 4.0.0, the filter() function in Puppet can do the same:

        ['aaa', 'bbb', 'ccc', 'aaaddd']. filter |$x| { $x =~ 'aaa' }
    DOC
             ) do |arguments|

    if arguments.size != 2
      raise(Puppet::ParseError, "grep(): Wrong number of arguments given #{arguments.size} for 2")
    end

    a = arguments[0]
    pattern = Regexp.new(arguments[1])

    a.grep(pattern)
  end
end

# vim: set ts=2 sw=2 et :
