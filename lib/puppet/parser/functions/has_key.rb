module Puppet::Parser::Functions

  newfunction(:has_key, :type => :rvalue, :doc => _(<<-'ENDHEREDOC')) do |args|
    Determine if a hash has a certain key value.

    Example:

        $my_hash = {'key_one' => 'value_one'}
        if has_key($my_hash, 'key_two') {
          notice('we will not reach here')
        }
        if has_key($my_hash, 'key_one') {
          notice('this will be printed')
        }

    ENDHEREDOC

    unless args.length == 2
      raise Puppet::ParseError, (_("has_key(): wrong number of arguments (%{num_args}; must be 2)") % { num_args: args.length, })
    end
    unless args[0].is_a?(Hash)
      raise Puppet::ParseError, _("has_key(): expects the first argument to be a hash, got %{val} which is of type %{arg_class}") % { val: args[0].inspect, arg_class: args[0].class, }
    end
    args[0].has_key?(args[1])

  end

end
