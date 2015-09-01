# Boolean check to determine whether a variable is of a given data type.
#
# @example how to check a data type
#   # check a data type
#       foo = 3
#       $bar = [1,2,3]
#       $baz = 'A string!'
#
#       if $foo.is_a(Integer) {
#         notify  { 'foo!': }
#       }
#       if $bar.is_a(Array) {
#         notify { 'bar!': }
#       }
#       if $baz.is_a(String) {
#         notify { 'baz!': }
#       }
#
# See the documentation for "The Puppet Type System" for more information about types.
# See the `assert_type()` function for flexible ways to assert the type of a value.
#
Puppet::Functions.create_function(:is_a) do
  def is_a(type, value)
    Puppet::Pops::Types::TypeCalculator.instance?(value,type)
  end
end
