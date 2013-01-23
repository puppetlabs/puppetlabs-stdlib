#
# strarraycat.rb
#
module Puppet::Parser::Functions
  newfunction(:strarraycat, :type => :rvalue, :doc => <<-EOS
Concatenates each value in an array with a string, or the values from another array. LHS arguments are prefixed to RHS. Third argument is optional and is a single character to insert between concatenated values

*Example 1:*

    strarraycat('/var/lib/git',['puppet','stdlib'],'/')

Would result in:

    [ '/var/lib/git/puppet', '/var/lib/git/stdlib' ]

Example 2:*

    strarraycat(['production', 'development'],['puppet','stdlib'], '/')

Would result in:

    [ 'production/puppet', 'production/stdlib', 'development/puppet', 'development/stdlib' ]

    EOS
  ) do |arguments|
    # validate correct number of args given
    unless ((arguments.size == 2) or (arguments.size == 3)) then
      raise(Puppet::ParseError, 'strarraycat(): Wrong number of arguments '+
           "given #{arguments.size} for 2 or 3")
    end

    # validate that we have a string and an array
    l = arguments[0]
    r = arguments[1]
    s = arguments[2]
    unless ((l.is_a?(Array) and r.is_a?(String)) or
            (l.is_a?(String) and r.is_a?(Array)) or
            (l.is_a?(Array) and r.is_a?(Array)))
      raise(Puppet::ParseError, 'strarraycat(): Requires two arrays, or a an array and a string to work with')
    end
    # validate separator char if given
    if s
      unless s =~ /^.$/
        raise(Puppet::ParseError, 'strarraycat(): Separator must be a single character')
      end
    else
      s = ''
    end

    # prefix with LHS
    if l.is_a?(String)
      result = r.map!{ |x| l + s + x }
    # postfix with RHS
    elsif r.is_a?(String)
      result = l.map!{ |x| x + s + r }
    else
      # concatenate array values
      # probably cleaner to do this with zip or map but seemed overly complex
      # when dealing with arrays of differing sizes
      result = []
      l.each do |left|
        r.each do |right|
          result.push(left + s + right)
        end
      end
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
