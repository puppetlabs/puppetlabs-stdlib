# frozen_string_literal: true

# @summary Get list of nested values from given hash
#   This function will return list of nested Hash values and returns list of values in form of Array
#
# @example Example Usage:
#   $hash = {
#     "key1" => "value1",
#     "key2" => { "key2.1" => "value2.1"},
#     "key3" => "value3"
#   }
#   $data = $hash.stdlib::nested_values
#   #Output : ["value1", "value2.1", "value3"]
Puppet::Functions.create_function(:'stdlib::nested_values') do
  # @param hash A (nested) hash
  # @return All the values found in the input hash included those deeply nested.
  dispatch :nested_values do
    param 'Hash', :hash
    return_type 'Array'
  end

  def nested_values(hash)
    hash.each_with_object([]) do |(_k, v), values|
      v.is_a?(Hash) ? values.concat(nested_values(v)) : (values << v)
    end
  end
end
