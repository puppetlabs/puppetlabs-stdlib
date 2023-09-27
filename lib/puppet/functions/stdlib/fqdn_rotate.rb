# frozen_string_literal: true

# @summary Rotates an array or string a random number of times, combining the `fqdn` fact and an optional seed for repeatable randomness.
Puppet::Functions.create_function(:'stdlib::fqdn_rotate') do
  # @param input
  #   The String you want rotated a random number of times
  # @param seeds
  #   One of more values to use as a custom seed. These will be combined with the host's FQDN
  #
  # @return [String] Returns the rotated String
  #
  # @example Rotating a String
  #   stdlib::fqdn_rotate('abcd')
  # @example Using a custom seed
  #   stdlib::fqdn_rotate('abcd', 'custom seed')
  dispatch :fqdn_rotate_string do
    param 'String', :input
    optional_repeated_param 'Variant[Integer,String]', :seeds
    return_type 'String'
  end

  # @param input
  #   The Array you want rotated a random number of times
  # @param seeds
  #   One of more values to use as a custom seed. These will be combined with the host's FQDN
  #
  # @return [String] Returns the rotated Array
  #
  # @example Rotating an Array
  #   stdlib::fqdn_rotate(['a', 'b', 'c', 'd'])
  # @example Using custom seeds
  #   stdlib::fqdn_rotate([1, 2, 3], 'custom', 'seed', 1)
  dispatch :fqdn_rotate_array do
    param 'Array', :input
    optional_repeated_param 'Variant[Integer,String]', :seeds
    return_type 'Array'
  end

  def fqdn_rotate_array(input, *seeds)
    # Check whether it makes sense to rotate ...
    return input if input.size <= 1

    result = input.clone

    require 'digest/md5'
    seed = Digest::MD5.hexdigest([fqdn_fact, seeds].join(':')).hex

    offset = Puppet::Util.deterministic_rand(seed, result.size).to_i

    offset.times do
      result.push result.shift
    end

    result
  end

  def fqdn_rotate_string(input, *seeds)
    fqdn_rotate_array(input.chars, seeds).join
  end

  private

  def fqdn_fact
    closure_scope['facts']['networking']['fqdn']
  end
end
