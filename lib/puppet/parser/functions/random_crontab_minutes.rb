#
# random_crontab_minutes.rb
#

module Puppet::Parser::Functions
  newfunction(:random_crontab_minutes, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    require 'md5'

    job_name = arguments[0]
    host     = arguments[1]

    #
    # Pick a random number based on the job and host name.  This will yield
    # the same value for exactly the same combination of the job and host name.
    #
    value = MD5.new(job_name + host).to_s.hex % 60

    # Minutes are from 0 to 59 inclusive ...
    value = value < 60 ? value : 59

    return value
  end
end

# vim: set ts=2 sw=2 et :
