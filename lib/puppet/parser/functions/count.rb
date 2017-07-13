module Puppet::Parser::Functions
  newfunction(:count, :type => :rvalue, :arity => -2, :doc => _(<<-EOS)
Takes an array as first argument and an optional second argument.
Count the number of elements in array that matches second argument.
If called with only an array it counts the number of elements that are not nil/undef.
    EOS
  ) do |args|

    if (args.size > 2) then
      raise(ArgumentError, _("count(): Wrong number of arguments given %{num_args} for 1 or 2.") % { num_args: args.size, })
    end

    collection, item = args

    if item then
      collection.count item
    else
      collection.count { |obj| obj != nil && obj != :undef && obj != '' }
    end
  end
end
