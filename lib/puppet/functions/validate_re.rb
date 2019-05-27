# @summary
#  Perform validation of a string against one or more regular
#  expressions.
#
Puppet::Functions.create_function(:validate_re) do
  # @param scope
  #   The main value that will be passed to the method
  #
  # @param args
  #   Any additional values that are to be passed to the method
  #   The first argument of this function should be a string to
  #   test, and the second argument should be a stringified regular expression
  #   (without the // delimiters) or an array of regular expressions
  #
  # @return [Boolean]
  #   `true` or `false` returned from the called function.
  dispatch :deprecation_gen do
    param 'Any', :scope
    repeated_param 'Any', :args
  end
  # Workaround PUP-4438 (fixed: https://github.com/puppetlabs/puppet/commit/e01c4dc924cd963ff6630008a5200fc6a2023b08#diff-
  #   c937cc584953271bb3d3b3c2cb141790R221) to support puppet < 4.1.0 and puppet < 3.8.1.
  def call(scope, *args)
    manipulated_args = [scope] + args
    self.class.dispatcher.dispatch(self, scope, manipulated_args)
  end

  def deprecation_gen(scope, *args)
    call_function('deprecation', 'validate_re', 'This method is deprecated, please use the stdlib validate_legacy function,
                    with Pattern[]. There is further documentation for validate_legacy function in the README.')
    scope.send('function_validate_re', args)
  end
end
