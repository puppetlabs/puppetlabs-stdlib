# @summary
#   Returns true if str ends with one of the prefixes given. Each of the prefixes should be a String.
#
Puppet::Functions.create_function(:'stdlib::end_with') do
  # @param test_string The string to check
  # @param suffixes The suffixes to check
  # @example
  #    'foobar'.stdlib::end_with('bar') => true
  #    'foobar'.stdlib::end_with('foo') => false
  #    'foobar'.stdlib::end_with(['foo', 'baz']) => false
  # @return [Boolean] True or False
  dispatch :end_with do
    param 'String[1]', :test_string
    param 'Variant[String[1],Array[String[1], 1]]', :suffixes
    return_type 'Boolean'
  end

  def end_with(test_string, suffixes)
    test_string.end_with?(*suffixes)
  end
end
