# @summary
#   Return true if test_string ends with suffux
#
#  @example
#    'foobar'.stdlib::end_with('bar') => true
#    'foobar'.stdlib::end_with('foo') => false
Puppet::Functions.create_function(:'stdlib::end_with') do
  # @param test_string the string to check
  # @param suffix the suffix to check
  #
  # @return [Boolean] True or False
  dispatch :end_with do
    param 'String[1]', :test_string
    param 'String[1]', :suffix
    return_type 'Boolean'
  end

  def end_with(test_string, suffix)
    test_string.end_with?(suffix)
  end
end
