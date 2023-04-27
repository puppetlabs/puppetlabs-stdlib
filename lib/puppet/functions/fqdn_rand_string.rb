# frozen_string_literal: true

# @summary
#   Generates a random alphanumeric string. Combining the `$fqdn` fact and an
#   optional seed for repeatable randomness.
#
# Optionally, you can specify a character set for the function (defaults to alphanumeric).
Puppet::Functions.create_function(:fqdn_rand_string) do
  # @param length The length of the resulting string.
  # @param charset The character set to use.
  # @param The seed for repeatable randomness.
  #
  # @return [String]
  #
  # @example Example Usage:
  #   fqdn_rand_string(10)
  #   fqdn_rand_string(10, 'ABCDEF!@$%^')
  #   fqdn_rand_string(10, '', 'custom seed')
  dispatch :fqdn_rand_string do
    param 'Integer[1]', :length
    optional_param 'String', :charset
    optional_repeated_param 'Any', :seed
  end

  def fqdn_rand_string(length, charset = '', *seed)
    charset = charset.chars.to_a

    charset = (0..9).map { |i| i.to_s } + ('A'..'Z').to_a + ('a'..'z').to_a if charset.empty?

    rand_string = ''
    length.times do |current|
      rand_string += charset[call_function('fqdn_rand', charset.size, (seed + [current + 1]).join(':'))]
    end

    rand_string
  end
end
