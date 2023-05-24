# frozen_string_literal: true

require 'digest'
# @summary
#   Run a SHA256 calculation against a given value.
Puppet::Functions.create_function(:'stdlib::sha256') do
  # @param my_data The ScalarData to evaluate
  # @example Check a simple string value
  #   stdlib::sha256('my string') == '2f7e2089add0288a309abd71ffcc3b3567e2d4215e20e6ed3b74d6042f7ef8e5'
  # @example Check a Sensitive datatype
  #   stdlib::sha256(sensitive('my string')) == '2f7e2089add0288a309abd71ffcc3b3567e2d4215e20e6ed3b74d6042f7ef8e5'
  # @example Check a number
  #   stdlib::sha256(100.0) == '43b87f618caab482ebe4976c92bcd6ad308b48055f1c27b4c574f3e31d7683e0'
  #   stdlib::sha256(100.00000) == '43b87f618caab482ebe4976c92bcd6ad308b48055f1c27b4c574f3e31d7683e0'
  # @return String
  dispatch :sha256 do
    param 'Variant[ScalarData, Sensitive[ScalarData], Binary, Sensitive[Binary]]', :my_data
    return_type 'String'
  end

  def sha256(my_data)
    Digest::SHA256.hexdigest(my_data.unwrap.to_s)
  rescue StandardError
    Digest::SHA256.hexdigest(my_data.to_s)
  end
end
