#
# min.rb
#
module Puppet::Parser::Functions
  newfunction(:min, type: :rvalue, doc: <<-EOS
    Returns the lowest value of all arguments.
    Requires at least one argument.
    EOS
             ) do |args|

    raise(Puppet::ParseError, 'min(): Wrong number of arguments need at least one') if args.empty?

    # Sometimes we get numbers as numerics and sometimes as strings.
    # We try to compare them as numbers when possible
    return args.min do |a, b|
      a.to_f <=> b.to_f if a.to_s =~ %r{\A^-?\d+(.\d+)?\z} && b.to_s =~ %r{\A-?\d+(.\d+)?\z}
      a.to_s <=> b.to_s
    end
  end
end
