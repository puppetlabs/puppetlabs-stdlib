#
# fact.rb
#

module Puppet::Parser::Functions
  newfunction(:fact, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "fact(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    fact = arguments[0]

    raise(Puppet::ParseError, 'fact(): You must provide ' +
      'fact name') if fact.empty?

    fact   = strinterp(fact) # Evaluate any interpolated variable names ...
    result = lookupvar(fact) # Get the value of interest from Facter ...

    #
    # Now this is a funny one ...  Puppet does not have a concept of
    # returning neither undef nor nil back for use within the Puppet DSL
    # and empty string is as closest to actual undef as you we can get
    # at this point in time ...
    #
    result = (not result or result.empty?) ? '' : result

    return result
  end
end

# vim: set ts=2 sw=2 et :

notice fact('interfaces')
notice fact('xyz')
notice fact('')
