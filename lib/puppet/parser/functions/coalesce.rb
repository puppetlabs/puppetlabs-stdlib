#
# coalesce.rb
#

module Puppet::Parser::Functions
  newfunction(:coalesce, :type => :rvalue, :doc => <<-EOS
Returns first non-empty argument.

From the Puppet DSL, the keyword 'undef' is treated as a zero-length string,
which is empty. This permits a compact selection between several variables:

  define myexec ( command => undef ) {
    $real_command = coalesce($command, $name)
  }
    EOS
  ) do |args|
    Puppet::Parser::Functions.autoloader.load(:empty) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:empty)

    result = :undef

    args.each do |arg|
      if not function_empty([arg]); then
        result = arg
        break
      end
    end

    result
  end
end
# vim: set ts=2 sw=2 et :
