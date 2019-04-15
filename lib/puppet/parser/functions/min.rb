#
# min.rb
#
module Puppet::Parser::Functions
  newfunction(:min, :type => :rvalue, :doc => <<-DOC
    @summary
      **Deprecated:** Returns the lowest value of all arguments.

    Requires at least one argument.

    @return
      The lowest value among the given arguments

    > **Note:** **Deprecated** from Puppet 6.0.0, this function has been replaced with a
    built-in [`min`](https://puppet.com/docs/puppet/latest/function.html#min) function.
    DOC
             ) do |args|

    raise(Puppet::ParseError, 'min(): Wrong number of arguments need at least one') if args.empty?

    # Sometimes we get numbers as numerics and sometimes as strings.
    # We try to compare them as numbers when possible
    return args.min do |a, b|
      if a.to_s =~ %r{\A^-?\d+(.\d+)?\z} && b.to_s =~ %r{\A-?\d+(.\d+)?\z}
        a.to_f <=> b.to_f
      else
        a.to_s <=> b.to_s
      end
    end
  end
end
