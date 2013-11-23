# Removes keys from the supplied hash if the value of that key is `undef`
module Puppet::Parser::Functions
  newfunction(:hash_compact, :type => :rvalue) do |args|
    hash = args.first
    hash.keys.each { |key| hash.delete(key) if hash[key].nil? }
    hash
  end
end
