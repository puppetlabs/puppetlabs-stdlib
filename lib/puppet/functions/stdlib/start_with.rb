# @summary
#   Returns true if str starts with one of the prefixes given. Each of the prefixes should be a String.
#
Puppet::Functions.create_function(:'stdlib::start_with') do
  # @param test_string The string to check
  # @param prefixes The prefixes to check.
  # @example
  #   'foobar'.stdlib::start_with('foo') => true
  #   'foobar'.stdlib::start_with('bar') => false
  #   'foObar'.stdlib::start_with(['bar', 'baz']) => false
  # @return [Boolean] True or False
  dispatch :start_with do
    param 'String[1]', :test_string
    param 'Variant[String[1],Array[String[1], 1]]', :prefixes
    return_type 'Boolean'
  end

  def start_with(test_string, prefixes)
    test_string.start_with?(*prefixes)
  end
end
