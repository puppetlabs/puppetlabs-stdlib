#
# delete_undef_values.rb
#
module Puppet::Parser::Functions
  newfunction(:delete_undef_values, :type => :rvalue, :doc => <<-DOC
    @summary
      Returns a copy of input hash or array with all undefs deleted.

    @example Example usage

      $hash = delete_undef_values({a=>'A', b=>'', c=>undef, d => false})
      Would return: {a => 'A', b => '', d => false}

      While:
      $array = delete_undef_values(['A','',undef,false])
      Would return: ['A','',false]

    > *Note:*
    Since Puppet 4.0.0 the equivalent can be performed with the built-in
    [`filter`](https://puppet.com/docs/puppet/latest/function.html#filter) function:
    $array.filter |$val| { $val =~ NotUndef }
    $hash.filter |$key, $val| { $val =~ NotUndef }

    @return [Array] The given array now issing of undefined values.
    DOC
             ) do |args|

    raise(Puppet::ParseError, "delete_undef_values(): Wrong number of arguments given (#{args.size})") if args.empty?

    unless args[0].is_a?(Array) || args[0].is_a?(Hash)
      raise(Puppet::ParseError, "delete_undef_values(): expected an array or hash, got #{args[0]} type  #{args[0].class} ")
    end
    result = args[0].dup
    if result.is_a?(Hash)
      result.delete_if { |_, val| val.equal?(:undef) || val.nil? }
    elsif result.is_a?(Array)
      result.delete :undef
      result.delete nil
    end
    result
  end
end
