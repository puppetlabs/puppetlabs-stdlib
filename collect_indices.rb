#
# collect_indices.rb
#

module Puppet::Parser::Functions
  newfunction(:collect_indices, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments.shift

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'Requires an array to work with')
    end

    indices = *arguments # Get them all ... Pokemon ...

    if not indices or indices.empty?
      raise(Puppet::ParseError, 'You must provide indices to collect')
    end

    indices_list = []

    indices.each do |i|
      if m = i.match(/^(\d+)\-(\d+)$/)
        start = m[1].to_i
        stop  = m[2].to_i

        raise(Puppet::ParseError, 'Stop index in given indices range ' +
          'is smaller than the start index') if start > stop

        (start .. stop).each { |i| indices_list << i.to_i }
      else
        if not i.match(/^\w+$/)
          raise(Puppet::ParseError, 'Unknown format of given index')
        end

        # In Puppet numbers are often string-encoded ...
        indices_list << i.to_i
      end
    end

    array = indices_list.collect { |i| array[i] }.compact

    return array
  end
end

# vim: set ts=2 sw=2 et :
