module Puppet::Parser::Functions
  newfunction(:basename, :type => :rvalue, :doc => <<-EOS
    Returns the basename of a path.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "basename(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    path = arguments[0]
    return File.basename(path)
  end
end

# vim: set ts=2 sw=2 et :
