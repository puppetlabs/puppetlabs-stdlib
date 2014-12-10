#
# yaml.rb
#

module Puppet::Parser::Functions
  newfunction(:yaml, :type => :rvalue, :arity => 1, :doc => <<-EOS
This converts any object to YAML output containing that object. 
    EOS
  ) do |arguments|
    return arguments[0].to_yaml
  end
end

# vim: set ts=2 sw=2 et :
