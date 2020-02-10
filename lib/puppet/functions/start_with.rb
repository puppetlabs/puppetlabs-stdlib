# @summary
#   Returns true if str starts with one of the prefixes given. Each of the prefixes should be a String.
#
# @example
#   'foobar'.start_with('foo') => true
#   'foobar'.start_with('bar') => false
#   'foObar'.start_with(['bar', 'baz']) => false
Puppet::Functions.create_function(:start_with) do
  # @param test_string The string to check
  # @param prefixes The prefixes to check.
  #
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
