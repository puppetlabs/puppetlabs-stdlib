# Returns whether or not a value is present in a hash
#
# Note that this is a relatively expensive operation versus a key lookup
#

Puppet::Functions.create_function(:'stdlib::has_value') do
  # @param h the hash
  # @param v the value
  # @return [Boolean] whether there exists a k for which h[k] = v
  # @example
  #   $h = { 'foo' => 'bar', }
  #   $h.stdlib::has_value('foo') => false
  #   $h.stdlib::has_value('bar') => true
  dispatch :value do
    param 'Hash', :h
    param 'Any', :v
    return_type 'Boolean'
  end

  def value(h, v)
    h.value?(v)
  end
end
