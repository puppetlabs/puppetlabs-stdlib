#
# collect_indices.rb
#

module Puppet::Parser::Functions
  newfunction(:collect_indices, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "collect_indices(): Wrong number of " +
      "arguments given (#{arguments.size} for 2)") if arguments.size < 2

    array      = arguments.shift
    array_size = array.size

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'collect_indices(): Requires an array ' +
        'to work with')
    end

    indices = *arguments # Get them all ... Pokemon ...

    if not indices or indices.empty?
      raise(Puppet::ParseError, 'collect_indices(): You must provide ' +
        'indices to collect')
    end

    indices_list = []

    indices.each do |i|
      if m = i.match(/^(\d+)\-(\d+)$/)
        start = m[1].to_i
        stop  = m[2].to_i

        if start > stop
          raise(Puppet::ParseError, 'collect_indices(): Stop index in ' +
            'given indices range is smaller than the start index')
        elsif stop > array_size - 1 # First element is at index 0 is it not?
          raise(Puppet::ParseError, 'collect_indices(): Stop index in ' +
            'given indices range exceeds array size')
        end

        (start .. stop).each { |i| indices_list << i.to_i }
      else
        # Only positive numbers allowed ...
        if not i.match(/^\d+$/)
          raise(Puppet::ParseError, 'collect_indices(): Unknown format ' +
            'of given index')
        end

        # In Puppet numbers are often string-encoded ...
        i = i.to_i

        if i > array_size - 1 # Same story.  First element is at index 0 ...
          raise(Puppet::ParseError, 'collect_indices(): Given index ' +
            'exceeds array size')
        end

        indices_list << i
      end
    end

    array = indices_list.collect { |i| array[i] }.compact

    return array
  end
end

# vim: set ts=2 sw=2 et :
