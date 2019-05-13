#
# any2array.rb
#
module Puppet::Parser::Functions
  newfunction(:any2array, :type => :rvalue, :doc => <<-DOC
    @summary
      This converts any object to an array containing that object.

    Empty argument lists are converted to an empty array. Arrays are left
    untouched. Hashes are converted to arrays of alternating keys and values.

    > *Note:*
      since Puppet 5.0.0 it is possible to create new data types for almost any
      datatype using the type system and the built-in
      [`Array.new`](https://puppet.com/docs/puppet/latest/function.html#conversion-to-array-and-tuple)
      function is used to create a new Array..

      ```
      $hsh = {'key' => 42, 'another-key' => 100}
      notice(Array($hsh))
      ```

    Would notice `[['key', 42], ['another-key', 100]]`

    The Array data type also has a special mode to "create an array if not already an array"

      ```
      notice(Array({'key' => 42, 'another-key' => 100}, true))
      ```

    Would notice `[{'key' => 42, 'another-key' => 100}]`, as the `true` flag prevents the hash from being
    transformed into an array.

    @return [Array] The new array containing the given object
  DOC
             ) do |arguments|

    if arguments.empty?
      return []
    end

    return arguments unless arguments.length == 1
    return arguments[0] if arguments[0].is_a?(Array)
    return [] if arguments == ['']
    if arguments[0].is_a?(Hash)
      result = []
      arguments[0].each do |key, value|
        result << key << value
      end
      return result
    end
    return arguments
  end
end

# vim: set ts=2 sw=2 et :
