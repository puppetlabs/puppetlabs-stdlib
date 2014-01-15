#
# ensure_packages.rb
#

module Puppet::Parser::Functions
  newfunction(:ensure_packages, :type => :statement, :doc => <<-EOS
Takes a list of packages and only installs them if they don't already exist.
    EOS
  ) do |arguments|

    if arguments.size != 1
      raise(Puppet::ParseError, "ensure_packages(): Wrong number of arguments " +
        "given (#{arguments.size} for 1)")
    end

    packages = Array(arguments[0])

    Puppet::Parser::Functions.function(:ensure_resource)
    packages.each { |package_name|
      function_ensure_resource(['package', package_name, {'ensure' => 'present' } ])
    }
  end
end

# vim: set ts=2 sw=2 et :
