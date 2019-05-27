# @summary
#   Returns true if the ipaddress is within the given CIDRs
#
# @example ip_in_range(<IPv4 Address>, <IPv4 CIDR>)
#   stdlib::ip_in_range('10.10.10.53', '10.10.10.0/24') => true
Puppet::Functions.create_function(:'stdlib::ip_in_range') do
  # @param ipaddress The IP address to check
  # @param range One CIDR or an array of CIDRs
  #   defining the range(s) to check against
  #
  # @return [Boolean] True or False
  dispatch :ip_in_range do
    param 'String', :ipaddress
    param 'Variant[String, Array]', :range
    return_type 'Boolean'
  end

  require 'ipaddr'
  def ip_in_range(ipaddress, range)
    ip = IPAddr.new(ipaddress)

    if range.is_a? Array
      ranges = range.map { |r| IPAddr.new(r) }
      ranges.any? { |rng| rng.include?(ip) }
    elsif range.is_a? String
      ranges = IPAddr.new(range)
      ranges.include?(ip)
    end
  end
end
