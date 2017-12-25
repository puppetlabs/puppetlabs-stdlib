# Takes a generic 'ensure' parameter (or its boolean equivalent)
# and converts it to an appropriate value for use with directory
# declaration.
Puppet::Functions.create_function(:ensure_directory) do
  # @param ensure_param Pass ensure value here
  # @return [String] 'directory' or 'absent'
  #
  # @example Calling the function with 'present'
  #   ensure_directory('present') # returns 'directory'
  #
  # @example Calling the function with boolean parameter
  #   ensure_directory(true) # returns 'directory'
  #
  # @example
  #   class myservice::config (
  #     Enum[present, absent] $ensure = present,
  #   ) {
  #     file { '/etc/myservice':
  #       ensure => ensure_directory($ensure),
  #       mode   => '0755',
  #     }
  #   }
  dispatch :ensure do
    param 'Variant[String, Boolean]', :ensure_param
  end

  def ensure(ensure_param)
    case ensure_param
    when 'present', true then
      'directory'
    when 'absent', false then
      'absent'
    else
      raise(ArgumentError, "ensure_directory(): invalid argument: '#{ensure_param}'.")
    end
  end
end
