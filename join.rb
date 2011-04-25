#
# join.rb
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-EOS
This function will allow to concatenate elements of an array together
with a given suffix and optionally with prefix if such is given ...

For example:

Given the following sample manifest:

   define iterator {
     notice $name
   }

   $array = ['a', 'b', 'c']

   $result = split(join($array, ',', 'letter_'), ',')

   notice $result

   iterator { $result: }

This will produce the following:

   notice: Scope(Class[main]): letter_a letter_b letter_c
   notice: Scope(Iterator[letter_a]): letter_a
   notice: Scope(Iterator[letter_b]): letter_b
   notice: Scope(Iterator[letter_c]): letter_c

Which allows you to avoid resorting to the following:

   $result = split(inline_template("<%= array.collect { |i| \"letter_#{i}\" }.join(',') %>"), ',')

Phasing out the need for use and abuse of the infamous inline_template
in the example above and which in this very case is extremely ugly as
we have to escape double-quotes to make Puppet parser not evaluate them.
    EOS
  ) do |arguments|

    # Technically we support three arguments but only first two are mandatory ...
    raise(Puppet::ParseError, "join(): Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    array = arguments[0]

    if not array.is_a?(Array)
      raise(Puppet::ParseError, 'join(): Requires an array to work with')
    end

    suffix = arguments[1]
    prefix = arguments[2] if arguments[2]

    raise(Puppet::ParseError, 'join(): You must provide suffix ' +
      'to join array elements with') if suffix.empty?

    if prefix and prefix.empty?
      raise(Puppet::ParseError, 'join(): You must provide prefix ' +
        'to add to join')
    end

    if prefix and not prefix.empty?
      result = prefix + array.join(suffix + prefix)
    else
      result = array.join(suffix)
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
