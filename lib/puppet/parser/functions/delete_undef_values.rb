module Puppet::Parser::Functions
  newfunction(:delete_undef_values, :type => :rvalue, :doc => _(<<-EOS)
Returns a copy of input hash or array with all undefs deleted.

*Examples:*

    $hash = delete_undef_values({a=>'A', b=>'', c=>undef, d => false})

Would return: {a => 'A', b => '', d => false}

    $array = delete_undef_values(['A','',undef,false])

Would return: ['A','',false]

      EOS
    ) do |args|

    raise(Puppet::ParseError, _("delete_undef_values(): Wrong number of arguments given (%{num_args})") % { num_args: args.size, }) if args.size < 1

    unless args[0].is_a? Array or args[0].is_a? Hash
      raise(Puppet::ParseError, _("delete_undef_values(): expected an array or hash, got %{arg_value} type %{arg_class} ") % { arg_value: args[0], arg_class: args[0].class })
    end
    result = args[0].dup
    if result.is_a?(Hash)
      result.delete_if {|key, val| val.equal? :undef}
    elsif result.is_a?(Array)
      result.delete :undef
    end
    result
  end
end
