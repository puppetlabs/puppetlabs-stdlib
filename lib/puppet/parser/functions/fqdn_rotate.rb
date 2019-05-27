#
# fqdn_rotate.rb
#
Puppet::Parser::Functions.newfunction(
  :fqdn_rotate,
  :type => :rvalue,
  :doc => <<-DOC
  @summary
    Rotates an array or string a random number of times, combining the `$fqdn` fact
    and an optional seed for repeatable randomness.

  @return
    rotated array or string

  @example Example Usage:
    fqdn_rotate(['a', 'b', 'c', 'd'])
    fqdn_rotate('abcd')
    fqdn_rotate([1, 2, 3], 'custom seed')
  DOC
) do |args|

  raise(Puppet::ParseError, "fqdn_rotate(): Wrong number of arguments given (#{args.size} for 1)") if args.empty?

  value = args.shift
  require 'digest/md5'

  unless value.is_a?(Array) || value.is_a?(String)
    raise(Puppet::ParseError, 'fqdn_rotate(): Requires either array or string to work with')
  end

  result = value.clone

  string = value.is_a?(String) ? true : false

  # Check whether it makes sense to rotate ...
  return result if result.size <= 1

  # We turn any string value into an array to be able to rotate ...
  result = string ? result.split('') : result

  elements = result.size

  seed = Digest::MD5.hexdigest([lookupvar('::fqdn'), args].join(':')).hex
  # deterministic_rand() was added in Puppet 3.2.0; reimplement if necessary
  if Puppet::Util.respond_to?(:deterministic_rand)
    offset = Puppet::Util.deterministic_rand(seed, elements).to_i
  else
    return offset = Random.new(seed).rand(elements) if defined?(Random) == 'constant' && Random.class == Class

    old_seed = srand(seed)
    offset = rand(elements)
    srand(old_seed)
  end
  offset.times do
    result.push result.shift
  end

  result = string ? result.join : result

  return result
end

# vim: set ts=2 sw=2 et :
