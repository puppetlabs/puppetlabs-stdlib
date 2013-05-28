module Puppet::Parser::Functions
  newfunction(:dirname_recursive, :type => :rvalue, :doc => <<-EOS
    Returns an array of recursive dirnames of a path.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "dirname(): Wrong number of arguments " +
      "given (#{arguments.size} for 4)") if arguments.size < 1

    path = arguments[0]
    excludes = arguments[1] || []
    upper_limit = arguments[2] || 2
    lower_limit = arguments[3] || 0

    # Validate arguments
    raise Puppet::ParseError, "'path' should be of type string, not #{path.class}." unless path.is_a? String
    raise Puppet::ParseError, "'excludes' should be of type array, not #{path.class}." unless excludes.is_a? Array
    raise Puppet::ParseError, "'upper_limit' should be of type integer, not #{path.class}." unless upper_limit.is_a? Integer
    raise Puppet::ParseError, "'lower_limit' should be of type integer, not #{path.class}." unless lower_limit.is_a? Integer

    dirnames = []
    levels = 0
    while not dirnames.include? File.dirname(path)
      path = File.dirname(path)
      levels += 1
      parts = path.split(File::ALT_SEPARATOR || File::SEPARATOR)
      break if excludes.include? path
      if parts[0] == '' or path == '/'
        # absolute path, parts includes /
        break if parts.size <= upper_limit
      else
        # relative path
        break if parts.size < upper_limit
      end
      break if path == '.'
      break if lower_limit != 0 and levels > lower_limit
      dirnames << path
    end
    dirnames
  end
end

# vim: set ts=2 sw=2 et :
