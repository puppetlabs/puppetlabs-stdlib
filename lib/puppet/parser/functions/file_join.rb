#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:file_join, :type => :rvalue, :doc => <<-EOS
This function joins an array into a string using the File separator.
This join is done intelligently so the File separator is not
repeated.

*Examples:*

    file_join(['/usr','bin','crontab'])

Would result in: "/usr/bin/crontab"

    file_join(['/usr/','/bin/','/crontab'])

Would result in: "/usr/bin/crontab"
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "file_join(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'file_join(): Requires array to work with')
    end

    result = File.join(array)

    return result
  end
end

# vim: set ts=2 sw=2 et :
