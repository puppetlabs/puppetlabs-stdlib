module Puppet::Parser::Functions

  newfunction(:validate_hash_content, :type => :statement, :doc => <<-'ENDHEREDOC') do |args|
    Check that all specified keys exist and have associated values in a hash

    Example:

        $my_hash = {'key_one' => 'value_one'}
        $my_hash = {'key_two' => ''}
        # this will throw an exception
        validate_hash_content($my_hash, 'key_two')
        # so will this
        validate_hash_content($my_hash, ['key_one', 'key_two'])

    ENDHEREDOC

    unless args.length == 2
      raise Puppet::ParseError, ("validate_hash_content(): wrong number of arguments (#{args.length}; must be 2)")
    end
    unless args[0].is_a?(Hash)
      raise Puppet::ParseError, "validate_hash_content(): expects the first argument to be a hash, got #{args[0].inspect} which is of type #{args[0].class}"
    end
    Array(args[1]).each {|k| raise "Hash does not have key #{k}" unless args[0].has_key?(k)}
    Array(args[1]).each {|k| raise "Value of key #{k} not set" if (args[0][k].respond_to?(:empty?) ? args[0][k].empty? : !args[0][k])}

  end

end
