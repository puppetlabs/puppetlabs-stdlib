#
# include.rb
#

# TODO(Krzysztof Wilczynski): We need to add support for regular expression ...

module Puppet::Parser::Functions
  newfunction(:include, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "include(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'include(): Requires an array to work with')
    end

    item = arguments[1]

    raise(Puppet::ParseError, 'include(): You must provide item ' +
      'to search for within given array') if item.empty?

    result = array.include?(item)

    return result
  end
end

# vim: set ts=2 sw=2 et :
