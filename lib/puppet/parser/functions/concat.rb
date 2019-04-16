#
# concat.rb
#
module Puppet::Parser::Functions
  newfunction(:concat, :type => :rvalue, :doc => <<-DOC
    @summary
      Appends the contents of multiple arrays into array 1.

    For example:
    * `concat(['1','2','3'],'4')` returns `['1','2','3','4']`.
    * `concat(['1','2','3'],'4',['5','6','7'])` returns `['1','2','3','4','5','6','7']`.

    > *Note:* Since Puppet 4.0, you can use the `+`` operator for concatenation of arrays and
    merge of hashes, and the `<<`` operator for appending:

    ```
    ['1','2','3'] + ['4','5','6'] + ['7','8','9'] # returns ['1','2','3','4','5','6','7','8','9']
    [1, 2, 3] << 4 # returns [1, 2, 3, 4]
    [1, 2, 3] << [4, 5] # returns [1, 2, 3, [4, 5]]
    ```

    @return [Array] The single concatenated array
  DOC
             ) do |arguments|

    # Check that more than 2 arguments have been given ...
    raise(Puppet::ParseError, "concat(): Wrong number of arguments given (#{arguments.size} for < 2)") if arguments.size < 2

    a = arguments[0]

    # Check that the first parameter is an array
    unless a.is_a?(Array)
      raise(Puppet::ParseError, 'concat(): Requires array to work with')
    end

    result = a
    arguments.shift

    arguments.each do |x|
      result += (x.is_a?(Array) ? x : [x])
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
