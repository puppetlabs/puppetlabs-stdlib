module Puppet::Parser::Functions
  newfunction(:hiera_enabled, :type => :rvalue, :doc => <<-EOS
    Returns true or false based on hiera being enabled.
    EOS
 ) do
    if Puppet.features.hiera? and Puppet::Parser::Functions.function(:hiera)
      true
    else
      false
    end
  end
end
