# frozen_string_literal: true

# @summary
#   Returns the type of the passed value.
#
# @example how to compare values' types
#   # compare the types of two values
#   if stdlib::type_of($first_value) != stdlib::type_of($second_value) { fail("first_value and second_value are different types") }
# @example how to compare against an abstract type
#   unless stdlib::type_of($first_value) <= Numeric { fail("first_value must be Numeric") }
#   unless stdlib::type_of{$first_value) <= Collection[1] { fail("first_value must be an Array or Hash, and contain at least one element") }
#
# See the documentation for "The Puppet Type System" for more information about types.
# See the `assert_type()` function for flexible ways to assert the type of a value.
#
# The built-in type() function in puppet is generally preferred over this function
# this function is provided for backwards compatibility.
Puppet::Functions.create_function(:'stdlib::type_of') do
  # @return [String]
  #   the type of the passed value
  #
  # @param value
  def type_of(value)
    Puppet::Pops::Types::TypeCalculator.infer_set(value)
  end
end
