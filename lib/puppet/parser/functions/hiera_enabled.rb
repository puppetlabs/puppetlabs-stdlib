module Puppet::Parser::Functions
  newfunction(:hiera_enabled, :type => :rvalue ) do
    if Puppet.features.hiera? and Puppet::Parser::Functions.function(:hiera)
      true
    else
      false
    end
  end
end
