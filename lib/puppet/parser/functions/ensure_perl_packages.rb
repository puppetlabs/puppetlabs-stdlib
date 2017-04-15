require 'puppet/parser/functions'
module Puppet::Parser::Functions
  newfunction(:ensure_perl_packages, :type => :statement, :doc => <<-EOS
Takes a list of perl module names (eg: Acme::Bleach) and creates package resources for each. Only supported for Debian & RedHat.
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "ensure_perl_packages(): Wrong number of arguments " +
          "given (#{arguments.size} for 1)") if arguments.size != 1

    case arguments[0]
    when String
      packages = [arguments[0]]
    when Array
      packages = arguments[0]
    else
      raise(Puppet::ParseError, "ensure_perl_packages(): Requires array " +
            "given (#{arguments[0].class})")
    end

    Puppet::Parser::Functions.function(:ensure_packages)

    packages.collect! { |x| x.gsub( '::', '-') }

    osfamily = lookupvar('osfamily')
    case osfamily
    when 'Debian'
      packages.collect! { |package| "lib#{package.downcase}-perl"}
      function_ensure_packages([packages])
    when 'RedHat'
      packages.collect! { |package| "perl-#{package}" }
      function_ensure_packages([packages])
    else
      err('I do not know how to name perl packages on osfamily #{osfamily}')
    end

  end
end
