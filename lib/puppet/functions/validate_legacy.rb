# frozen_string_literal: true

# @summary
#   **Deprecated:** Validate a value against both the target_type (new).
Puppet::Functions.create_function(:validate_legacy) do
  # The function checks a value against both the target_type (new).
  # @param scope
  #   The main value that will be passed to the method
  # @param target_type
  # @param function_name
  #   Unused
  # @param value
  # @param args
  #   Any additional values that are to be passed to the method
  # @return
  #   A boolean value (`true` or `false`) returned from the called function.
  dispatch :validate_legacy do
    param 'Any', :scope
    param 'Type', :target_type
    param 'String', :function_name
    param 'Any', :value
    repeated_param 'Any', :args
  end

  # @param scope
  #   The main value that will be passed to the method
  # @param type_string
  # @param function_name
  #   Unused
  # @param value
  # @param args Any additional values that are to be passed to the method
  # @return Legacy validation method
  #
  dispatch :validate_legacy_s do
    param 'Any', :scope
    param 'String', :type_string
    param 'String', :function_name
    param 'Any', :value
    repeated_param 'Any', :args
  end

  # Workaround PUP-4438 (fixed: https://github.com/puppetlabs/puppet/commit/e01c4dc924cd963ff6630008a5200fc6a2023b08#diff-
  #   c937cc584953271bb3d3b3c2cb141790R221) to support puppet < 4.1.0 and puppet < 3.8.1.
  def call(scope, *args)
    manipulated_args = [scope] + args
    self.class.dispatcher.dispatch(self, scope, manipulated_args)
  end

  def validate_legacy_s(scope, type_string, *args)
    t = Puppet::Pops::Types::TypeParser.new.parse(type_string, scope)
    validate_legacy(scope, t, *args)
  end

  def validate_legacy(_scope, target_type, _function_name, value, *_prev_args)
    call_function('deprecation', 'validate_legacy', 'This method is deprecated, please use Puppet data types to validate parameters')
    if assert_type(target_type, value)
      # "Silently" passes
    else
      inferred_type = Puppet::Pops::Types::TypeCalculator.infer_set(value)
      error_msg = Puppet::Pops::Types::TypeMismatchDescriber.new.describe_mismatch("validate_legacy(#{target_type}, ...)", target_type, inferred_type)
      call_function('fail', error_msg)
    end
  end

  def assert_type(type, value)
    Puppet::Pops::Types::TypeCalculator.instance?(type, value)
  end
end
