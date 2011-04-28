#
# strftime.rb
#

module Puppet::Parser::Functions
  newfunction(:strftime, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "strftime(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    format = arguments[0]

    raise(Puppet::ParseError, 'strftime(): You must provide ' +
      'format for evaluation') if format.empty?

    # The Time Zone argument is optional ...
    time_zone = arguments[1] if arguments[1]

    time = Time.new

    if time_zone and not time_zone.empty?
      original_zone = ENV['TZ']

      local_time = time.clone
      local_time = local_time.utc

      ENV['TZ'] = time_zone

      time = local_time.localtime

      ENV['TZ'] = original_zone
    end

    result = time.strftime(format)

    return result
  end
end

# vim: set ts=2 sw=2 et :
