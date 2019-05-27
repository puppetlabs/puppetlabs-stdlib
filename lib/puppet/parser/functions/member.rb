# TODO(Krzysztof Wilczynski): We need to add support for regular expression ...
# TODO(Krzysztof Wilczynski): Support for strings and hashes too ...
#
# member.rb
#
module Puppet::Parser::Functions
  newfunction(:member, :type => :rvalue, :doc => <<-DOC
    @summary
      This function determines if a variable is a member of an array.

    The variable can be a string, fixnum, or array.

    > **Note**: This function does not support nested arrays. If the first argument contains
    nested arrays, it will not recurse through them.

    @example **Usage**
      member(['a','b'], 'b') # Returns: true
      member(['a', 'b', 'c'], ['a', 'b']) # Returns: true
      member(['a','b'], 'c') # Returns: false
      member(['a', 'b', 'c'], ['d', 'b']) # Returns: false

    > *Note:*
    Since Puppet 4.0.0 the same can be performed in the Puppet language.
    For single values the operator `in` can be used:
    `'a' in ['a', 'b']  # true`
    For arrays by using operator `-` to compute a diff:
    `['d', 'b'] - ['a', 'b', 'c'] == []  # false because 'd' is not subtracted`
    `['a', 'b'] - ['a', 'b', 'c'] == []  # true because both 'a' and 'b' are subtracted`

    @return
      Returns whether the given value was a member of the array

    > **Note** that since Puppet 5.2.0, the general form to test the content of an array or
    hash is to use the built-in [`any`](https://puppet.com/docs/puppet/latest/function.html#any)
    and [`all`](https://puppet.com/docs/puppet/latest/function.html#all) functions.
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "member(): Wrong number of arguments given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    unless array.is_a?(Array)
      raise(Puppet::ParseError, 'member(): Requires array to work with')
    end

    unless arguments[1].is_a?(String) || arguments[1].is_a?(Integer) || arguments[1].is_a?(Array)
      raise(Puppet::ParseError, 'member(): Item to search for must be a string, fixnum, or array')
    end

    item = if arguments[1].is_a?(String) || arguments[1].is_a?(Integer)
             [arguments[1]]
           else
             arguments[1]
           end

    raise(Puppet::ParseError, 'member(): You must provide item to search for within array given') if item.respond_to?('empty?') && item.empty?

    result = (item - array).empty?

    return result
  end
end

# vim: set ts=2 sw=2 et :
