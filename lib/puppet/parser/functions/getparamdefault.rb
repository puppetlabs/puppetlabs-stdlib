module Puppet::Parser::Functions
  newfunction(:getparamdefault, :type => :rvalue, :doc => <<-EOS
Takes a type or resource reference and name of the parameter and returns
default value of parameter for that type/resource (or empty string if default
is not set).

*Examples:*

    package { 'apache2': provider => apt }
    getparamdefault(Package['apache2'], provider)

Would return '' (default provider was not defined).

    Package { provider => aptitude }

    node example.com {
      package { 'apache2': provider => apt }
      getparamdefault(Package['apache2'], provider)
    }

Would return 'aptitude'.

    Package { provider => aptitude }

    node example.com {
      Package { provider => apt }
      package { 'apache2': }
      getparamdefault(Package['apache2'], provider)
    }

Would return 'apt'.

    Package { provider => aptitude }

    node example.com {
      Package { provider => apt }
      getparamdefault(Package, provider)
    }

Would return 'apt'.

    getparamdefault(Foo['bar'], geez)

Would not compile (resource Foo[bar] does not exist)

    getparamdefault(Foo, geez)

Would not compile (type Foo does not exist)

EOS
  ) do |args|

    unless args.length == 2
      raise Puppet::ParseError, ("getparamdefault(): wrong number of arguments (#{args.length} for 2)")
    end

    ref, name = args

    raise(Puppet::ParseError,'getparamdefault(): parameter name must be a string') unless name.instance_of? String

    return '' if name.empty?

    ref = ref.to_s
    
    if resource = findresource(ref)
      params = resource.scope.lookupdefaults(resource.type)
    elsif ref.match(/^((::){0,1}[A-Z][-\w]*)+$/) and find_resource_type(ref)
      # Note, find_resource_type('type') and find_resource_type('Type') would
      # find same resource type, but lookupdefaults() works only with
      # capitalized 'Type's. We force user to provide capitalized type names.
      # That's why the regular expression here. The expression is copied
      # from lexer (CLASSREF token).
      params = lookupdefaults(ref)
    else
      raise(Puppet::ParseError, "'#{ref}' is neither a resource nor a type")
    end
    if param = params[name.intern]
      return param.value
    end

    return ''
  end
end
