module Puppet::Parser::Functions
  newfunction(:merge, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Merges two or more hashes together and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two' => 2}
        $hash2 = {'two' => 'dos', 'three' => 'tres'}
        $merged_hash = merge($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}

    When there is a duplicate key, the key in the rightmost hash will "win."

    If the last argument is an array of hashes, it performs the merge described above on all of them.
    For example:

        $arr = {'one' => 1, 'two' => 2}
        $hash2 = [ {'two' => 'dos', 'three' => 'tres'}, { 'two' => 'due' } ]
        $merged_hash = merge($hash1, $arr)
        # The result is:
        # $result =  [ {'one' => 1, 'two' => 'dos', 'three' => 'tres'}, {'one' => 1, 'two' => 'due', 'three' => 'tres'} ]

    ENDHEREDOC

    if args.length < 2
      raise Puppet::ParseError, ("merge(): wrong number of arguments (#{args.length}; must be at least 2)")
    end

    final_arg = args.pop

    result = [final_arg].flatten.collect do |x|
      # The hash we accumulate into
      accumulator = Hash.new
      # Merge into the accumulator hash
      (args + [x]).each do |arg|
        next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
        unless arg.is_a?(Hash)
          raise Puppet::ParseError, "merge: unexpected argument type #{arg.class}, only expects hash arguments"
        end
        accumulator.merge!(arg)
      end
      accumulator
    end

    if final_arg.is_a? Array
      return result
    else
      return result[0]
    end
  end
end
