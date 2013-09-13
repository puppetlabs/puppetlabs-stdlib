module Puppet::Parser::Functions
  newfunction(:max, :type => :rvalue, :arity => -2, :doc => <<-EOS
    Returns the highest value of all arguments.
    Requires at least one argument.
    EOS
  ) do |args|

    # Sometimes we get numbers as numerics and sometimes as strings.
    # We try to compare them as numbers when possible
    return args.max do |a,b|
      if a.to_s =~ /\A-?\d+(.\d+)?\z/ and b.to_s =~ /\A-?\d+(.\d+)?\z/ then
        a.to_f <=> b.to_f
      else
        a.to_s <=> b.to_s
      end
    end
  end
end
