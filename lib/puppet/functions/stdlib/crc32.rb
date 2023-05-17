# frozen_string_literal: true

require 'zlib'
# @note
#   The CRC32 algorithm can easily generate collisions,
#   but may be useful for generating sharding, describing
#   secrets, or seeding nonce values.
#
# @summary
#   Run a CRC32 calculation against a given value.
Puppet::Functions.create_function(:'stdlib::crc32') do
  # @param my_data The ScalarData to evaluate
  # @example Check a simple string value
  #   stdlib::crc32('my string') == '18fbd270'
  # @example Check a Sensitive datatype
  #   stdlib::crc32(sensitive('my string')) == '18fbd270'
  # @example Check a number
  #   stdlib::crc32(100.0) == 'a3fd429a'
  #   stdlib::crc32(100.00000) == 'a3fd429a'
  # @return String
  dispatch :crc32 do
    param 'Variant[ScalarData, Sensitive[ScalarData], Binary, Sensitive[Binary]]', :my_data
    return_type 'String'
  end

  def crc32(my_data)
    Zlib.crc32(my_data.unwrap.to_s).to_s(16).downcase
  rescue StandardError
    Zlib.crc32(my_data.to_s).to_s(16).downcase
  end
end
