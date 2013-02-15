module Puppet::Parser::Functions

  newfunction(:has_element, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Determine if an array has an element with a matching value.

    Example:

        $my_array = ['key_one']
        if has_element($my_array, 'key_two') {
          notice('we will not reach here')
        }
        if has_element($my_array, 'key_one') {
          notice('this will be printed')
        }

    ENDHEREDOC

    unless args.length == 2
      raise Puppet::ParseError, ("has_element(): wrong number of arguments (#{args.length}; must be 2)")
    end
    unless args[0].is_a?(Array)
      raise Puppet::ParseError, "has_element(): expects the first argument to be an array, got #{args[0].inspect} which is of type #{args[0].class}"
    end
    args[0].include?(args[1])

  end

end
