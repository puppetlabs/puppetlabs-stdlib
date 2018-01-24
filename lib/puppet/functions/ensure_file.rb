# Takes a generic 'ensure' parameter (or its boolean equivalent)
# and converts it to an appropriate value for use with file
# declaration.
Puppet::Functions.create_function(:ensure_file) do
  # @param ensure_param Pass ensure value here
  # @return [String] 'file' or 'absent'
  #
  # @example Calling the function with 'present'
  #   ensure_file('present') # returns 'file'
  #
  # @example Calling the function with boolean parameter:
  #   ensure_file(true) # returns 'file'
  #
  # @example Usage context:
  #   class myservice::config (
  #     Enum[present, absent] $ensure = present,
  #   ) {
  #     file { '/etc/myservice':
  #       ensure => ensure_file($ensure),
  #       mode   => '0644',
  #     }
  #   }
  dispatch :ensure do
    param 'Variant[String, Boolean]', :ensure_param
  end

  def ensure(ensure_param)
    case ensure_param
    when 'present', true then
      'file'
    when 'absent', false then
      'absent'
    else
      raise(ArgumentError, "ensure_file(): invalid argument: '#{ensure_param}'.")
    end
  end
end
