#
# type.rb
#
module Puppet::Parser::Functions
  newfunction(:type, :type => :rvalue, :doc => <<-DOC
    @summary
      **DEPRECATED:** This function will cease to function on Puppet 4;
     please use type3x() before upgrading to Puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.

    @return the type when passed a value. Type can be one of:

    * string
    * array
    * hash
    * float
    * integer
    * boolean
  DOC
             ) do |args|

    warning("type() DEPRECATED: This function will cease to function on Puppet 4; please use type3x() before upgrading to puppet 4 for backwards-compatibility, or migrate to the new parser's typing system.") # rubocop:disable Metrics/LineLength : Cannot reduce line length
    unless Puppet::Parser::Functions.autoloader.loaded?(:type3x)
      Puppet::Parser::Functions.autoloader.load(:type3x)
    end
    function_type3x(args)
  end
end

# vim: set ts=2 sw=2 et :
