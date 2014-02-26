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

    file_join('/usr/','/bin/','/crontab')

Would result in: "/usr/bin/crontab"

    file_join([['/usr/','local'],'/bin/'],'/crontab')

Would result in: "/usr/local/bin/crontab"
    EOS
  ) do |arguments|

    array = arguments.flatten()

    array.each do |i| 
      unless i.is_a?(String) 
        raise(Puppet::ParseError, 'file_join(): Requires only strings or nested arrays of strings.')
      end
    end

    result = File.join(array)

    return result
  end
end

# vim: set ts=2 sw=2 et :
