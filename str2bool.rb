#
# str2bool.rb
#

module Puppet::Parser::Functions
  newfunction(:str2bool, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "str2bool(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    string = arguments[0]

    unless string.is_a?(String)
      raise(Puppet::ParseError, 'str2bool(): Requires either ' +
        'string to work with')
    end

    # We consider all the yes, no, y, n and so on too ...
    result = case string
      #
      # This is how undef looks like in Puppet ...
      # We yield false in this case.
      #
      when /^$/, '' then false
      when /^(1|t|y|true|yes)$/ then true
      when /^(0|f|n|false|no)$/ then false
      # This is not likely to happen ...
      when /^(undef|undefined)$/ then false
      else
        raise(Puppet::ParseError, 'str2bool(): Unknown type of boolean given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
