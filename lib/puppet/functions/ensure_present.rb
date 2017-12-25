# Converts a boolean to a generic 'ensure' value.
Puppet::Functions.create_function(:ensure_present) do
  # @param ensure_param Pass a boolean here
  # @return [String] 'present' or 'absent'
  #
  # @example Calling the function
  #   ensure_present(true) # returns 'present'
  #   ensure_present(false) # returns 'absent'
  dispatch :ensure do
    param 'Boolean', :ensure_param
  end

  def ensure(ensure_param)
    if ensure_param
      'present'
    else
      'absent'
    end
  end
end
