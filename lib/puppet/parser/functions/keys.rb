#
# keys.rb
#

module Puppet::Parser::Functions
  newfunction(:keys, :type => :rvalue, :doc => _(<<-EOS)
Returns the keys of a hash as an array.
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, _("keys(): Wrong number of arguments given (#{arguments.size} for 1)")) if arguments.size < 1

    hash = arguments[0]

    unless hash.is_a?(Hash)
      raise(Puppet::ParseError, _('keys(): Requires hash to work with'))
    end

    result = hash.keys

    return result
  end
end

# vim: set ts=2 sw=2 et :
