# Takes a generic 'ensure' parameter (or its boolean equivalent)
# and converts it to an appropriate value for use with symlink
# declaration.
Puppet::Functions.create_function(:ensure_link) do
  # @param ensure_param Pass ensure value here
  # @return [String] 'link' or 'absent'
  #
  # @example Calling the function with 'present'
  #   ensure_link('present') # returns 'link'
  #
  # @example Calling the function with boolean parameter:
  #   ensure_link(true) # returns 'link'
  #
  # @example Usage context:
  #   class myservice::config (
  #     Enum[present, absent] $ensure = present,
  #   ) {
  #     file { '/etc/myservice':
  #       ensure => file,
  #     }
  #
  #     file { '/etc/myservice-link':
  #       ensure => ensure_link($ensure),
  #       target => '/etc/myservice'
  #     }
  #   }
  dispatch :ensure do
    param 'Variant[String, Boolean]', :ensure_param
  end

  def ensure(ensure_param)
    case ensure_param
    when 'present', true then
      'link'
    when 'absent', false then
      'absent'
    else
      raise(ArgumentError, "ensure_link(): invalid argument: '#{ensure_param}'.")
    end
  end
end
