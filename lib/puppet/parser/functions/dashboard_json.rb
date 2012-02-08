#
# dashboard_json.rb
#

module Puppet::Parser::Functions
  newfunction(:dashboard_json, :type => :rvalue, :doc => <<-EOS
This function returns dashboard JSON data string and converts it.

*Examples:*

    # $::ntpserver = "[\\\"0.pool.ntp.org\\\"]"
    $ntpserver = dashboard_json($::ntpserver)

Would result in: ["0.pool.ntp.org"]
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "dashboard_json(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    json = arguments[0].gsub(/\\/,'')

    PSON.load(json) unless json.nil?
  end
end

# vim: set ts=2 sw=2 et :
