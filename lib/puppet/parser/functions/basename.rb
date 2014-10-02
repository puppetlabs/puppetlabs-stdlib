module Puppet::Parser::Functions
  newfunction(:basename, :type => :rvalue, :arity => 1, doc => <<-EOS
    Returns the basename of a path.
    EOS
  ) do |arguments|

    path = arguments[0]
    return File.basename(path)
  end
end

# vim: set ts=2 sw=2 et :
