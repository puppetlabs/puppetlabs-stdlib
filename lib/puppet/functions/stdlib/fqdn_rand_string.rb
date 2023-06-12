# frozen_string_literal: true

# @summary
#   Generates a random alphanumeric string. Combining the `$fqdn` fact and an
#   optional seed for repeatable randomness.
#
# Optionally, you can specify a character set for the function (defaults to alphanumeric).
Puppet::Functions.create_function(:'stdlib::fqdn_rand_string') do
  # @param length The length of the resulting string.
  # @param charset The character set to use.
  # @param seed The seed for repeatable randomness.
  #
  # @return [String]
  #
  # @example Example Usage:
  #   stdlib::fqdn_rand_string(10)
  #   stdlib::fqdn_rand_string(10, 'ABCDEF!@$%^')
  #   stdlib::fqdn_rand_string(10, undef, 'custom seed')
  dispatch :fqdn_rand_string do
    param 'Integer[1]', :length
    optional_param 'Optional[String]', :charset
    optional_repeated_param 'Any', :seed
  end

  def fqdn_rand_string(length, charset = nil, *seed)
    charset = if charset && !charset.empty?
                charset.chars.to_a
              else
                (0..9).map(&:to_s) + ('A'..'Z').to_a + ('a'..'z').to_a
              end

    rand_string = ''
    length.times do |current|
      rand_string += charset[call_function('fqdn_rand', charset.size, (seed + [current + 1]).join(':'))]
    end

    rand_string
  end
end
