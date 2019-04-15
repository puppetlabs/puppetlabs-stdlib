#
# dig44.rb
#
module Puppet::Parser::Functions
  newfunction(
    :dig44,
    :type => :rvalue,
    :arity => -2,
    :doc => <<-DOC
    @summary
      **DEPRECATED**: Looks up into a complex structure of arrays and hashes and returns a value
      or the default value if nothing was found.

    Key can contain slashes to describe path components. The function will go down
    the structure and try to extract the required value.

    ```
    $data = {
      'a' => {
        'b' => [
          'b1',
          'b2',
          'b3',
        ]
      }
    }

    $value = dig44($data, ['a', 'b', 2])
    # $value = 'b3'

    # with all possible options
    $value = dig44($data, ['a', 'b', 2], 'not_found')
    # $value = 'b3'

    # using the default value
    $value = dig44($data, ['a', 'b', 'c', 'd'], 'not_found')
    # $value = 'not_found'
    ```

    > **Note:* **Deprecated** This function has been replaced with a built-in
      [`dig`](https://puppet.com/docs/puppet/latest/function.html#dig) function as of
      Puppet 4.5.0.

    @return [String] 'not_found' will be returned if nothing is found
    @return [Any] the value that was searched for
  DOC
  ) do |arguments|
    # Two arguments are required
    raise(Puppet::ParseError, "dig44(): Wrong number of arguments given (#{arguments.size} for at least 2)") if arguments.size < 2

    data, path, default = *arguments

    raise(Puppet::ParseError, "dig44(): first argument must be a hash or an array, given #{data.class.name}") unless data.is_a?(Hash) || data.is_a?(Array)
    raise(Puppet::ParseError, "dig44(): second argument must be an array, given #{path.class.name}") unless path.is_a? Array

    value = path.reduce(data) do |structure, key|
      break unless structure.is_a?(Hash) || structure.is_a?(Array)
      if structure.is_a? Array
        begin
          key = Integer key
        rescue
          break
        end
      end
      break if structure[key].nil? || structure[key] == :undef
      structure[key]
    end
    value.nil? ? default : value
  end
end
