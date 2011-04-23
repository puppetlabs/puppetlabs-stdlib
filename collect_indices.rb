#
# collect_indices.rb
#

module Puppet::Parser::Functions
  newfunction(:collect_indices, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array   = arguments.shift
    indices = *arguments # Get them all ... Pokemon ...

    if not indices or indices.empty?
      raise(Puppet::ParseError, 'You must provide indices to collect')
    end

    # In Puppet numbers are often string-encoded ...
    array = indices.collect { |i| array[i.to_i] }.compact

    return array
  end
end

# vim: set ts=2 sw=2 et :
