# @summary
#   **Deprecated:** A function to eventually replace the old size() function for stdlib
#
# The original size() function did not handle Puppets new type capabilities, so this function
# is a Puppet 4 compatible solution.
#
# > **Note:** **Deprecated** from Puppet 6.0.0, this function has been replaced with a
# built-in [`length`](https://puppet.com/docs/puppet/latest/function.html#length) function.
#
Puppet::Functions.create_function(:length) do
  # @param value
  #   The value whose length is to be found
  #
  # @return [Integer]
  #   The length of the given object
  dispatch :length do
    param 'Variant[String,Array,Hash]', :value
  end
  def length(value)
    if value.is_a?(String)
      result = value.length
    elsif value.is_a?(Array) || value.is_a?(Hash)
      result = value.size
    end
    result
  end
end
