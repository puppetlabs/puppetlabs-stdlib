#
# load_json.rb
#

module Puppet::Parser::Functions
  newfunction(:load_json, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "load_json(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    json = arguments[0]
    
    require 'json'

    JSON.load(json)

  end
end

# vim: set ts=2 sw=2 et :
