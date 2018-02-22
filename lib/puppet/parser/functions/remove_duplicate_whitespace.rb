#
#  remove_duplicate_whitespace.rb
#
module Puppet::Parser::Functions
  newfunction(:remove_duplicate_whitespace, :type => :rvalue, :doc => <<-DOC
    This function replaces one or multiple whitespaces with a single one from a string or from
    every string inside an array.

    *Examples:*

        remove_duplicate_whitespace("    aaa   bla")

    Would result in: " aaa bla"
    DOC
             ) do |arguments|

    raise(Puppet::ParseError, "remove_duplicate_whitespace(): Wrong number of arguments given (#{arguments.size} for 1)") if arguments.empty?

    value = arguments[0]

    unless value.is_a?(Array) || value.is_a?(String)
      raise(Puppet::ParseError, 'remove_duplicate_whitespace(): Requires either array or string to work with')
    end

    result = if value.is_a?(Array)
               value.map { |i| i.is_a?(String) ? i.gsub(%r{\s+}, ' ') : i }
             else
               value.gsub(%r{\s+}, ' ')
             end

    return result
  end
end

# vim: set ts=2 sw=2 et :
