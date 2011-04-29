#
# values_at.rb
#

# TODO(Krzysztof Wilczynski): Support for hashes would be nice too ...
# TODO(Krzysztof Wilczynski): We probably need to approach numeric values differently ...

module Puppet::Parser::Functions
  newfunction(:values_at, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "values_at(): Wrong number of " +
      "arguments given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments.shift

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'values_at(): Requires an array ' +
        'to work with')
    end

    indices = *arguments # Get them all ... Pokemon ...

    if not indices or indices.empty?
      raise(Puppet::ParseError, 'values_at(): You must provide ' +
        'at least one positive index to collect')
    end

    result       = []
    indices_list = []

    indices.each do |i|
      if m = i.match(/^(\d+)(\.\.\.?|\-)(\d+)$/)
        start = m[1].to_i
        stop  = m[3].to_i

        type = m[2]

        if start > stop
          raise(Puppet::ParseError, 'values_at(): Stop index in ' +
            'given indices range is smaller than the start index')
        elsif stop > array.size - 1 # First element is at index 0 is it not?
          raise(Puppet::ParseError, 'values_at(): Stop index in ' +
            'given indices range exceeds array size')
        end

        range = case type
          when /^(\.\.|\-)$/ then (start .. stop)
          when /^(\.\.\.)$/  then (start ... stop) # Exclusive of last element ...
        end

        range.each { |i| indices_list << i.to_i }
      else
        # Only positive numbers allowed in this case ...
        if not i.match(/^\d+$/)
          raise(Puppet::ParseError, 'values_at(): Unknown format ' +
            'of given index')
        end

        # In Puppet numbers are often string-encoded ...
        i = i.to_i

        if i > array.size - 1 # Same story.  First element is at index 0 ...
          raise(Puppet::ParseError, 'values_at(): Given index ' +
            'exceeds array size')
        end

        indices_list << i
      end
    end

    # We remove nil values as they make no sense in Puppet DSL ...
    result = indices_list.collect { |i| array[i] }.compact

    return result
  end
end

# vim: set ts=2 sw=2 et :
