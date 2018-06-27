# Uses sprintf with named references.
#
# The first parameter is format string describing how the rest of the parameters in the hash
# should be formatted. See the documentation for the `Kernel::sprintf` function in Ruby for
# all the details.
#
# In the given argument hash with parameters, all keys are converted to symbols so they work
# with the `sprintf` function.
#
# @example Format a string and number
#   $output = sprintf_hash('String: %<foo>s / number converted to binary: %<number>b',
#                          { 'foo' => 'a string', 'number' => 5 })
#   # $output = 'String: a string / number converted to binary: 101'
#
# Note that since Puppet 4.10.10, and 5.3.4 this functionality is supported by the
# `sprintf` function in puppet core.
#
Puppet::Functions.create_function(:sprintf_hash) do
  # @param format The format to use.
  # @param arguments Hash with parameters.
  # @return The formatted string.
  # dispatch :sprintf_hash do
  #   param 'String', :format
  #   param 'Hash', :arguments
  #   # Disabled for now. This gives issues on puppet 4.7.1.
  #   # return_type 'String'
  # end

  dispatch :deprecation_gen do
    param 'Any', :scope
    repeated_param 'Any', :args
  end

  def call(scope, *args)
    manipulated_args = [scope] + args
    self.class.dispatcher.dispatch(self, scope, manipulated_args)
  end

  def deprecation_gen(scope, *args)
    call_function('deprecation', 'sprintf_hash', 'This method is deprecated as of puppet 4.10..10, please use the built in sprintf_hash method instead.')
    scope.send('sprintf_hash', args)
  end
end
