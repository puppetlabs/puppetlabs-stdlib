#
# dig.rb
#
module Puppet::Parser::Functions
  newfunction(:dig, :type => :rvalue, :doc => <<-DOC
    @summary
      **DEPRECATED** Retrieves a value within multiple layers of hashes and arrays via an
      array of keys containing a path.

    @return
      The function goes through the structure by each path component and tries to return
      the value at the end of the path.

    In addition to the required path argument, the function accepts the default argument.
    It is returned if the path is not correct, if no value was found, or if any other error
    has occurred.

      ```ruby
      $data = {
        'a' => {
          'b' => [
            'b1',
            'b2',
            'b3',
          ]
        }
      }

      $value = dig($data, ['a', 'b', 2])
      # $value = 'b3'

      # with all possible options
      $value = dig($data, ['a', 'b', 2], 'not_found')
      # $value = 'b3'

      # using the default value
      $value = dig($data, ['a', 'b', 'c', 'd'], 'not_found')
      # $value = 'not_found'
      ```

      1. `$data` The data structure we are working with.
      2. `['a', 'b', 2]` The path array.
      3. `not_found` The default value. It is returned if nothing is found.

    > **Note:*
      **Deprecated** This function has been replaced with a built-in
      [`dig`](https://puppet.com/docs/puppet/latest/function.html#dig) function as of
      Puppet 4.5.0. Use [`dig44()`](#dig44) for backwards compatibility or use the new version.
    DOC
             ) do |arguments|
    warning('dig() DEPRECATED: This function has been replaced in Puppet 4.5.0, please use dig44() for backwards compatibility or use the new version.')
    unless Puppet::Parser::Functions.autoloader.loaded?(:dig44)
      Puppet::Parser::Functions.autoloader.load(:dig44)
    end
    function_dig44(arguments)
  end
end
