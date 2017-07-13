#
# unique.rb
#

module Puppet::Parser::Functions
  newfunction(:unique, :type => :rvalue, :doc => _(<<-EOS)
This function will remove duplicates from strings and arrays.

*Examples:*

    unique("aabbcc")

Will return:

    abc

You can also use this with arrays:

    unique(["a","a","b","b","c","c"])

This returns:

    ["a","b","c"]
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("unique(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size }) if arguments.size < 1

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, _('unique(): Requires either array or string to work with'))
    end

    result = value.clone

    string = value.is_a?(String) ? true : false

    # We turn any string value into an array to be able to shuffle ...
    result = string ? result.split('') : result
    result = result.uniq # Remove duplicates ...
    result = string ? result.join : result

    return result
  end
end

# vim: set ts=2 sw=2 et :
