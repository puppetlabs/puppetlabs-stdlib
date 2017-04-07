# A simple and safe way to get a value from a data structure. Like $facts.
# This uses the same dot syntax that Facter cli uses and will return undef
# if any part of the resolved value doesn't exist (instead of failing as
# using the raw data structure would).
#
# @example Display a deeply nested fact
#
#       $docker_ip = $facts.value('networking.interfaces.docker0.ip')
#
#       if($docker_ip) {
#         notify { "The Docker interface is: ${docker_ip}": }
#       }
#
#
# Note: This wraps the dig() function in a more discoverable call style.
# An equivalent dig call would look like:
#
#       $docker_ip = $facts.dig('networking', 'interfaces', 'docker0', 'ip')
#
Puppet::Functions.create_function(:value) do
  dispatch :value do
    param 'Any',    :data
    param 'String', :lookup_key
  end

  def value(data, lookup_key)
    call_function('dig', data, *lookup_key.split('.'))
  end
end
