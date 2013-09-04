#
# reject.rb
#

module Puppet::Parser::Functions
  newfunction(:reject, :type => :rvalue, :arity => 2, :doc => <<-EOS) do |args|
This function searches through an array and rejects all elements that match
the provided regular expression.

*Examples:*

    reject(['aaa','bbb','ccc','aaaddd'], 'aaa')

Would return:

    ['bbb','ccc']
EOS

    ary = args[0]
    pattern = Regexp.new(args[1])

    ary.reject { |e| e =~ pattern }
  end
end

# vim: set ts=2 sw=2 et :
