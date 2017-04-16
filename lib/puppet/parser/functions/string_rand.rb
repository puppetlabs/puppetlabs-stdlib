require 'digest/md5'

Puppet::Parser::Functions::newfunction(:string_rand, :arity => -2, :type => :rvalue, :doc =>
  "Usage: `string_rand(MAX, SEED)`. MAX is required and must be a positive
  integer; SEED is also required and can be any number or string.

  Generates a random whole number greater than or equal to 0 and less than MAX,
  using the value of SEED for repeatable randomness.

  This function can be useful to generate a consistent number that will be used
  across multiple nodes that may be part of a similar role/service. For example
  a ID used to identify a clustered service.") do |args|
    max = args.shift.to_i
    seed = Digest::MD5.hexdigest(args.shift).hex
    Puppet::Util.deterministic_rand(seed,max)
end
