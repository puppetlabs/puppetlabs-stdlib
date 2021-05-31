# frozen_string_literal: true

# @summary
#   This function will return the first value in a list of values that is not
#   undefined or an empty string.
#
Puppet::Functions.create_function(:pick_default) do
  # @param scope
  #   The main value that will be passed to the method
  #
  # @param args
  #   Any additional values that are to be passed to the method
  #   The first argument of this function should be a string to
  #   test, and the second argument should be a stringified regular expression
  #   (without the // delimiters) or an array of regular expressions
  #
  # @return
  #   This function is similar to a coalesce function in SQL in that it will return
  #   the first value in a list of values that is not undefined or an empty string
  #   If no value is found, it will return the last argument.
  dispatch :to_namespaced_function do
    param 'Any', :scope
    repeated_param 'Any', :args
  end
  # Workaround PUP-4438 (fixed: https://github.com/puppetlabs/puppet/commit/e01c4dc924cd963ff6630008a5200fc6a2023b08#diff-
  #   c937cc584953271bb3d3b3c2cb141790R221) to support puppet < 4.1.0 and puppet < 3.8.1.
  def call(scope, *args)
    manipulated_args = [scope] + args
    self.class.dispatcher.dispatch(self, scope, manipulated_args)
  end

  def to_namespaced_function(scope, *args)
    scope.send('function_stlib::pick_default', args)
  end
end
