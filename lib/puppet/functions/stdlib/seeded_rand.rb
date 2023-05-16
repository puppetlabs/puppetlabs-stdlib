# frozen_string_literal: true

# @summary
#   Generates a random whole number greater than or equal to 0 and less than max, using the value of seed for repeatable randomness.
Puppet::Functions.create_function(:'stdlib::seeded_rand') do
  # @param max The maximum value.
  # @param seed The seed used for repeatable randomness.
  #
  # @return [Integer]
  #   A random number greater than or equal to 0 and less than max
  dispatch :seeded_rand do
    param 'Integer[1]', :max
    param 'String', :seed
  end

  def seeded_rand(max, seed)
    require 'digest/md5'

    seed = Digest::MD5.hexdigest(seed).hex
    Puppet::Util.deterministic_rand_int(seed, max)
  end
end
