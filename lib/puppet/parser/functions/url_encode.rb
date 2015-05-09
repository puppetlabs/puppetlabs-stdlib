#
#  url_encode.rb
#
require 'erb'

module Puppet::Parser::Functions
  newfunction(:url_encode, :type => :rvalue, :doc => <<-EOS
    Percent-encode URI significant/illegal characters in a 
    string or array of strings. Passing a URL to this function will 
    return an encoded URL string which can then be interpolated, as-is, into
    another URL string as a parameter value. Requires either a single 
    string or an array as an input.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "url_encode(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'url_encode(): Requires either ' +
        'array or string to work with')
    end

    if value.is_a?(Array)
      # Numbers in Puppet are often string-encoded which is troublesome ...
      result = value.collect { |i| i.is_a?(String) ? ERB::Util.url_encode(i) : i }
    else
      result = ERB::Util.url_encode(value)
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
