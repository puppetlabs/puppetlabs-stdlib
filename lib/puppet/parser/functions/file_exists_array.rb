require"puppet"

module Puppet::Parser::Functions
  newfunction(:file_exists_array, :type => :rvalue, :doc => <<-EOS
Returns an array of existing files from the passed array to this function.
    EOS
 ) do |args|
    raise Puppet::ParseError, ("file_exists_array: Wrong number of arguments (#{args.length}; must be = 1)") unless args.length == 1

    unless args[0].is_a?(Array)
      raise Puppet::ParseError, ("file_exists_array: Wrong argument type, must be an Array")
    end

    r_value = []
    args[0].each do |file|
      if File.file?(file)
        r_value.push(file)
      end
    end
    return r_value
  end
end
