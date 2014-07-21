module Puppet::Parser::Functions
  newfunction(:deep_merge, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Deep merges two or more hashes together using gem *deep_merge* and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two', => [1]}
        $hash2 = {'two' => [2], 'three', => 'tres'}
        $merged_hash = deep_merge($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash =  {'one' => 1, 'two' => [1,2], 'three' => 'tres'}

    This function raise an error if *deep_merge* gem is not available.

    ENDHEREDOC

    begin
      require 'deep_merge'
    rescue LoadError
      raise Puppet::ParseError, ("deep_merge(): gem *deep_merge* is required to use this function")
    end

    if args.length < 2
      raise Puppet::ParseError, ("deep_merge(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    # The hash we accumulate into
    accumulator = Hash.new
    # Merge into the accumulator hash
    args.each do |arg|
      next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, "deep_merge: unexpected argument type #{arg.class}, only expects hash arguments"
      end
      accumulator.deep_merge!(arg)
    end
    # Return the fully merged hash
    accumulator
  end
end
