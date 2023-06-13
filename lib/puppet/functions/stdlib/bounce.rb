# frozen_string_literal: true

# @summary Method to return the passed values
#   This function returns the passed value as parameters. If the passed argument is hash then it will return hash.
#   It will require for deferred function to deferr the different data types like String, Array, Hash & etc.
#
# @example Example Usage:
#   $str = "abc"
#   $data = $str.stdlib::bounce
#   #Output : "abc"
#
#   $hash = {
#     "key1" => "value1",
#   }
#   $data = $hash.stdlib::bounce
#   #Output : { "key1": "value1"}
#
#   $array = ["item1", "item2"]
#   $data = $array.stdlib::bounce
#   #Output : ["item1", "item2"]
Puppet::Functions.create_function(:'stdlib::bounce') do
  # @param String, Integer, Array, Hash
  # @return The return value will be same as passed value.
  dispatch :bounce do
    param 'Any', :args
    return_type 'Any'
  end

  def bounce(args)
    args
  end
end
