#
# size.rb
#
module Puppet::Parser::Functions
  newfunction(:size, :type => :rvalue, :doc => <<-DOC
    Returns the number of elements in a string, an array or a hash

    Note that since Puppet 5.4.0, the length() function in Puppet is preferred over this. For versions
    of Puppet < 5.4.0 use the stdlib length() function.
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "size(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    item = arguments[0]

    function_deprecation([:size, 'This method is going to be deprecated, please use the stdlib length function.'])

    if item.is_a?(String)

      begin
        #
        # Check whether your item is a numeric value or not ...
        # This will take care about positive and/or negative numbers
        # for both integer and floating-point values ...
        #
        # Please note that Puppet has no notion of hexadecimal
        # nor octal numbers for its DSL at this point in time ...
        #
        Float(item)

        raise(Puppet::ParseError, 'size(): Requires either string, array or hash to work with')
      rescue ArgumentError
        result = item.size
      end

    elsif item.is_a?(Array) || item.is_a?(Hash)
      result = item.size
    else
      raise(Puppet::ParseError, 'size(): Unknown type given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
