module Puppet::Parser::Functions
  newfunction(:hiera_enabled, :type => :rvalue ) do
    #    begin
    #      require 'hiera'
    #      true if Puppet::Parser::Functions.function 'hiera'
    #    rescue LoadError => e
    #      false
    #    end
    #true if Puppet.features.hiera?
    if Puppet.features.hiera? and Puppet::Parser::Functions.function(:hiera)
      true
    else
      false
    end
  end
end
