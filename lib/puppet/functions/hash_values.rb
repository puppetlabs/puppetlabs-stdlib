# frozen_string_literal: true

# This function will return list of Hash values, the return value will be Array
# NOTE : This function is expecting only Hash and return value will be Array
#
# @example :
# $hash = {
#   "key1" => "value1",
#   "key2" => { "key2.1" => "value2.1"}
# }
# $hash.hash_value
#
# Output : ["value1", "value2.1"]
#
Puppet::Functions.create_function(:hash_values) do
  dispatch :hash_values do
    param 'Hash', :options
    return_type 'Array'
  end

  def hash_values(options)
    options.each_with_object([]) do |(_k, v), values|
      v.is_a?(Hash) ? values.concat(hash_values(v)) : (values << v)
    end
  end
end
