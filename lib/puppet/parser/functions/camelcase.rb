#
#  camelcase.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#
module Puppet::Parser::Functions
  newfunction(:camelcase, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated** Converts the case of a string or all strings in an array to camel case.

    > *Note:*
      **Deprecated** from Puppet 6.0.0, this function has been replaced with
      a built-in [`camelcase`](https://puppet.com/docs/puppet/latest/function.html#camelcase)
      function.

    @return [String] The converted String, if it was a String that was given
    @return [Array[String]] The converted Array, if it was a Array that was given
  DOC
             ) do |arguments|

    raise(Puppet::ParseError, "camelcase(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]
    klass = value.class

    unless [Array, String].include?(klass)
      raise(Puppet::ParseError, 'camelcase(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               # Numbers in Puppet are often string-encoded which is troublesome ...
               value.map { |i| i.is_a?(String) ? i.split('_').map { |e| e.capitalize }.join : i }
             else
               value.split('_').map { |e| e.capitalize }.join
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
