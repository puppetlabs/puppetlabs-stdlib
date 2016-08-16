module Puppet::Parser::Functions
  newfunction(:hiera_or_lookup, :type => :rvalue) do |args|
    if Puppet.version =~ /^3/
      function_hiera(args)
    elsif Puppet.version =~ /^4/
      args_4x = case args.count
                when 1
                  args
                when 2
                  [args.first, {'default_value' => args.last}]
                when 3
                  [args[0], {'default_value' => args[1]}]
                else
                  fail("don't understand hiera_or_lookup arguments: #{args.inspect}")
                end
      call_function('lookup', args_4x)
    end
  end # end function
end # end module
