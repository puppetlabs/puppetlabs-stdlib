#
# reject.rb
#

module Puppet::Parser::Functions
  newfunction(:reject, :type => :rvalue, :doc => <<-EOS
This function searches through an array and rejects all elements that match
the provided regular expression.

*Examples:*

    reject(['aaa','bbb','ccc','aaaddd'], 'aaa')

Would return:

    ['bbb','ccc']
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "reject(): Wrong number of arguments "+
        "given #{arguments.size} for 2")
    end

    a = arguments[0]
    pattern = Regexp.new(arguments[1])

    a.reject{|e| e =~ pattern }

  end
end

# vim: set ts=2 sw=2 et :
