module Puppet::Parser::Functions
  newfunction(:merge, :type => :rvalue, :doc => _(<<-'ENDHEREDOC')) do |args|
    Merges two or more hashes together and returns the resulting hash.

    For example:

        $hash1 = {'one' => 1, 'two', => 2}
        $hash2 = {'two' => 'dos', 'three', => 'tres'}
        $merged_hash = merge($hash1, $hash2)
        # The resulting hash is equivalent to:
        # $merged_hash =  {'one' => 1, 'two' => 'dos', 'three' => 'tres'}

    When there is a duplicate key, the key in the rightmost hash will "win."

    ENDHEREDOC

    if args.length < 2
      raise Puppet::ParseError, (_("merge(): wrong number of arguments (%{num_args}; must be at least 2)") % { num_args: args.length, })
    end

    # The hash we accumulate into
    accumulator = Hash.new
    # Merge into the accumulator hash
    args.each do |arg|
      next if arg.is_a? String and arg.empty? # empty string is synonym for puppet's undef
      unless arg.is_a?(Hash)
        raise Puppet::ParseError, _("merge: unexpected argument type %{arg_class}, only expects hash arguments") % { arg_class: arg.class, }
      end
      accumulator.merge!(arg)
    end
    # Return the fully merged hash
    accumulator
  end
end
