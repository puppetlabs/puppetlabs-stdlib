require"puppet"

module Puppet::Parser::Functions
  newfunction(:dir_exists, :type => :rvalue, :doc => <<-EOS
Returns true if the directory passed to this function exists.
    EOS
  ) do |args|
    raise Puppet::ParseError, ("dir_exists: Wrong number of arguments (#{args.length}; must be = 1)") unless args.length == 1

    unless args[0].is_a?(String)
      raise Puppet::ParseError, ("dir_exists: Wrong argument type, must be a String")
    end

    if File.directory?(args[0])
      return true
    else
      return false
    end
  end
end
