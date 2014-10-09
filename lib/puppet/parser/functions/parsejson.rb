#
# parsejson.rb
#

module Puppet::Parser::Functions
  newfunction(:parsejson, :type => :rvalue, :arity => 1, :doc => <<-EOS
This function accepts JSON as a string and converts into the correct Puppet
structure.
    EOS
  ) do |arguments|

    json = arguments[0]

    # PSON is natively available in puppet
    PSON.load(json)
  end
end

# vim: set ts=2 sw=2 et :
