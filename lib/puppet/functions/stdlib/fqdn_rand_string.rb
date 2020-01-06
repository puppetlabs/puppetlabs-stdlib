# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#     @summary
#    Generates a random alphanumeric string. Combining the `$fqdn` fact and an
#    optional seed for repeatable randomness.
#
#  Optionally, you can specify a character set for the function (defaults to alphanumeric).
#
#  Arguments
#  * An integer, specifying the length of the resulting string.
#  * Optionally, a string specifying the character set.
#  * Optionally, a string specifying the seed for repeatable randomness.
#
#  @return [String]
#
#  @example Example Usage:
#    fqdn_rand_string(10)
#    fqdn_rand_string(10, 'ABCDEF!@$%^')
#    fqdn_rand_string(10, '', 'custom seed')
#
#
Puppet::Functions.create_function(:'stdlib::fqdn_rand_string') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    raise(ArgumentError, 'fqdn_rand_string(): wrong number of arguments (0 for 1)') if args.empty?
    Puppet::Parser::Functions.function('is_integer')
    raise(ArgumentError, 'fqdn_rand_string(): first argument must be a positive integer') unless function_is_integer([args[0]]) && args[0].to_i > 0
    raise(ArgumentError, 'fqdn_rand_string(): second argument must be undef or a string') unless args[1].nil? || args[1].is_a?(String)

    Puppet::Parser::Functions.function('fqdn_rand')

    length = args.shift.to_i
    charset = args.shift.to_s.chars.to_a

    charset = (0..9).map { |i| i.to_s } + ('A'..'Z').to_a + ('a'..'z').to_a if charset.empty?

    rand_string = ''
    for current in 1..length # rubocop:disable Style/For : An each loop would not work correctly in this circumstance
      rand_string << charset[function_fqdn_rand([charset.size, (args + [current.to_s]).join(':')]).to_i]
    end

    rand_string
  end
end
