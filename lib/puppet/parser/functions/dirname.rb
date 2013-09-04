module Puppet::Parser::Functions
  newfunction(:dirname, :type => :rvalue, :arity => 1, :doc => <<-EOS
    Returns the dirname of a path.
    EOS
  ) do |arguments|

    path = arguments[0]
    return File.dirname(path)
  end
end

# vim: set ts=2 sw=2 et :
