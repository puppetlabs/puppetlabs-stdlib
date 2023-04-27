# frozen_string_literal: true

# @summary Returns boolean based on network interfaces present and their attribute values.
#
# Can be called with one, or two arguments.
Puppet::Functions.create_function(:'stdlib::has_interface_with') do
  # @param interface
  #   The name of an interface
  # @return [Boolean] Returns `true` if `interface` exists and `false` otherwise
  # @example When called with a single argument, the presence of the interface is checked
  #   stdlib::has_interface_with('lo') # Returns `true`
  dispatch :has_interface do
    param 'String[1]', :interface
    return_type 'Boolean'
  end

  # @param kind
  #   A supported interface attribute
  # @param value
  #   The value of the attribute
  # @return [Boolean] Returns `true` if any of the interfaces in the `networking` fact has a `kind` attribute with the value `value`. Otherwise returns `false`
  # @example Checking if an interface exists with a given mac address
  #   stdlib::has_interface_with('macaddress', 'x:x:x:x:x:x') # Returns `false`
  # @example Checking if an interface exists with a given IP address
  #   stdlib::has_interface_with('ipaddress', '127.0.0.1') # Returns `true`
  dispatch :has_interface_with do
    param "Enum['macaddress','netmask','ipaddress','network','ip','mac']", :kind
    param 'String[1]', :value
    return_type 'Boolean'
  end

  def has_interface(interface) # rubocop:disable Naming/PredicateName
    interfaces.key? interface
  end

  def has_interface_with(kind, value) # rubocop:disable Naming/PredicateName
    # For compatibility with older version of function that used the legacy facts, alias `ip` with `ipaddress` and `mac` with `macaddress`
    kind = 'ip' if kind == 'ipaddress'
    kind = 'mac' if kind == 'macaddress'

    interfaces.any? { |_interface, params| params[kind] == value }
  end

  def interfaces
    closure_scope['facts']['networking']['interfaces']
  end
end
