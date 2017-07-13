#
# grep.rb
#

module Puppet::Parser::Functions
  newfunction(:grep, :type => :rvalue, :doc => _(<<-EOS)
This function searches through an array and returns any elements that match
the provided regular expression.

*Examples:*

    grep(['aaa','bbb','ccc','aaaddd'], 'aaa')

Would return:

    ['aaa','aaaddd']
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, _("grep(): Wrong number of arguments given %{num_args} for 2") % { num_args: arguments.size, })
    end

    a = arguments[0]
    pattern = Regexp.new(arguments[1])

    a.grep(pattern)

  end
end

# vim: set ts=2 sw=2 et :
