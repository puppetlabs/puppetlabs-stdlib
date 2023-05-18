# frozen_string_literal: true

#
# suffix.rb
#
module Puppet::Parser::Functions
  newfunction(:suffix, type: :rvalue, doc: <<-DOC
    @summary
      This function applies a suffix to all elements in an array, or to the keys
      in a hash.

    @return
      Array or Hash with updated elements containing the passed suffix

    @example **Usage**

      suffix(['a','b','c'], 'p')
      Will return: ['ap','bp','cp']

    > *Note:* that since Puppet 4.0.0 the general way to modify values is in array is by using the map
    function in Puppet. This example does the same as the example above:

    ```['a', 'b', 'c'].map |$x| { "${x}p" }```

  DOC
  ) do |arguments|
    # Technically we support two arguments but only first is mandatory ...
    raise(Puppet::ParseError, "suffix(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    enumerable = arguments[0]

    raise Puppet::ParseError, "suffix(): expected first argument to be an Array or a Hash, got #{enumerable.inspect}" unless enumerable.is_a?(Array) || enumerable.is_a?(Hash)

    suffix = arguments[1] if arguments[1]

    raise Puppet::ParseError, "suffix(): expected second argument to be a String, got #{suffix.inspect}" if suffix && !(suffix.is_a? String)

    result = if enumerable.is_a?(Array)
               # Turn everything into string same as join would do ...
               enumerable.map do |i|
                 i = i.to_s
                 suffix ? i + suffix : i
               end
             else
               enumerable.to_h do |k, v|
                 k = k.to_s
                 [suffix ? k + suffix : k, v]
               end
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
