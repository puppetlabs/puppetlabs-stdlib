module Puppet::Parser::Functions
  newfunction(:filter_hash, :doc => <<-'ENDHEREDOC', :type => :rvalue) do |args|
    Filters a hash of hashes:
      x = { a => { b => c }, b => { b => d }}

      filter_hash(x, "a") -> x = { a => { b => c }}
    ENDHEREDOC
    if (args.length != 2) then
      raise Puppet::ParseError, ("filter_hash(): wrong number of arguments (#{args.length}; must be 2)")
    end

    result = Hash.new

    existing_hash = args[0]
    wanted_key = Regexp.new(args[1])

    existing_hash.keys.grep(wanted_key) do | k |
        result[k] = existing_hash[k]
        debug("filter_hash: #{k} matches query #{wanted_key}")
    end

    result
  end
end
