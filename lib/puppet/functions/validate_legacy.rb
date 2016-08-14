Puppet::Functions.create_function(:validate_legacy, Puppet::Functions::InternalFunction) do
  # The function checks a value against both the target_type (new) and the previous_validation function (old).

  dispatch :validate_legacy do
    param 'Type', :target_type
    param 'String', :previous_validation
    param 'NotUndef', :value
    optional_param 'Any', :args
  end
  dispatch :validate_legacy_s do
    scope_param
    param 'String', :type_string
    param 'String', :previous_validation
    param 'NotUndef', :value
    optional_repeated_param 'Any', :args
  end

  def validate_legacy_s(scope, type_string, *args)
    t = Puppet::Pops::Types::TypeParser.new.parse(type_string, scope)
    validate_legacy(t, *args)
  end

  def validate_legacy(target_type, previous_validation, value, *prev_args)
    if assert_type(target_type, value)
      if previous_validation(previous_validation, value, *prev_args)
        # Silently passes
      else
        Puppet.warn("Accepting previously invalid value for target_type '#{target_type}'")
      end
    else
      inferred_type = Puppet::Pops::Types::TypeCalculator.infer_set(value)
      error_msg = Puppet::Pops::Types::TypeMismatchDescriber.new.describe_mismatch(previous_validation, target_type, inferred_type)
      if previous_validation(previous_validation, value, *prev_args)
        Puppet.warn(error_msg)
      else
        call_function('fail', error_msg)
      end
    end
  end

  def previous_validation(previous_validation, value, *prev_args)
    # Call the previous validation function and catch any errors. Return true if no errors are thrown.
    begin
      call_function(previous_validation, value, *prev_args)
      true
    rescue Puppet::ParseError
      false
    end
  end

  def assert_type(type, value)
    Puppet::Pops::Types::TypeCalculator.instance?(type, value)
  end
end
