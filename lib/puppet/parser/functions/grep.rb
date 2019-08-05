#
# grep.rb
#
module Puppet::Parser::Functions
  newfunction(:grep, :type => :rvalue, :doc => <<-DOC
    @summary
      This function searches through an array and returns any elements that match
      the provided regular expression.

    @return
      array of elements that match the provided regular expression.
    @example Example Usage:
      grep(['aaa','bbb','ccc','aaaddd'], 'aaa') # Returns ['aaa','aaaddd']

    > **Note:** that since Puppet 4.0.0, the built-in
    [`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function does
    the "same" - as any logic can be used to filter, as opposed to just regular expressions:
    ```['aaa', 'bbb', 'ccc', 'aaaddd']. filter |$x| { $x =~ 'aaa' }```
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
