#
# has_key.rb
#
module Puppet::Parser::Functions
  newfunction(:has_key, :type => :rvalue, :doc => <<-'DOC') do |args|
    Determine if a hash has a certain key value.

    Example:

        $my_hash = {'key_one' => 'value_one'}
        if has_key($my_hash, 'key_two') {
          notice('we will not reach here')
        }
        if has_key($my_hash, 'key_one') {
          notice('this will be printed')
        }

    Note: Since Puppet 4.0.0 this can be achieved in the Puppet language with the following equivalent expression:

       $my_hash = {'key_one' => 'value_one'}
       if 'key_one' in $my_hash {
         notice('this will be printed')
       }
    DOC

    unless args.length == 2
      raise Puppet::ParseError, "has_key(): wrong number of arguments (#{args.length}; must be 2)"
    end
    unless args[0].is_a?(Hash)
      raise Puppet::ParseError, "has_key(): expects the first argument to be a hash, got #{args[0].inspect} which is of type #{args[0].class}"
    end
    args[0].key?(args[1])
  end
end
