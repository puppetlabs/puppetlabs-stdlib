# Shorthand for bool ? true value : false value.
#
# @example
#   $number_sign = ifelse($i >= 0, "positive", "negative")
#
Puppet::Functions.create_function(:ifelse) do
  # @param bool Boolean condition
  # @param iftrue Value to return if condition is true.
  # @param iffalse Value to return if condition is false.
  # @return Value from `$iftrue` or `$iffalse` depending on the boolean condition.
  dispatch :ifelse do
    param 'Boolean', :bool
    param 'Any', :iftrue
    param 'Any', :iffalse
  end

  def ifelse(bool, iftrue, iffalse)
    bool ? iftrue : iffalse
  end
end
