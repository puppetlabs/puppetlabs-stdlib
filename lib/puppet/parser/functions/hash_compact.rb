# Removes keys from the supplied hash if the value of that key is `:undef`
module Puppet::Parser::Functions
  newfunction(:hash_compact, :type => :rvalue) do |args|
    raise "you can only compact a hash" unless args.first.is_a?(Hash)
    hash = args.first

    hash.keys.each do |key|
      hash.delete(key) if hash[key] == :undef
    end

    hash
  end
end
