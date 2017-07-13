#
#  sort.rb
#  Please note: This function is an implementation of a Ruby class and as such may not be entirely UTF8 compatible. To ensure compatibility please use this function with Ruby 2.4.0 or greater - https://bugs.ruby-lang.org/issues/10085.
#

module Puppet::Parser::Functions
  newfunction(:sort, :type => :rvalue, :doc => _(<<-EOS)
Sorts strings and arrays lexically.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, _("sort(): Wrong number of arguments given (%{num_args} for 1)") % { num_args: arguments.size })
    end

    value = arguments[0]

    if value.is_a?(Array) then
      value.sort
    elsif value.is_a?(String) then
      value.split("").sort.join("")
    end

  end
end

# vim: set ts=2 sw=2 et :
