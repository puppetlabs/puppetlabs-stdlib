require 'uri'
module Puppet::Parser::Functions

  newfunction(:validate_url, :doc => <<-'ENDHEREDOC') do |args|
    Validate that the passed argument is a valid URL string.
    The first argument is the URL to validate. The second (optional) argument 
    is the scheme or schemes that will be accepted for this call to validate_url.
    Catalog compilation if this check fails.

    The following values will pass:

        validate_url('http://puppetlabs.com')
        $my_url = "http://forge.puppetlabs.com"
        validate_url($my_url)
        validate_url("http://puppetlabs.com",["puppetlabs"])

    The following values will fail, causing compilation to abort:

        validate_url('puppetlabs.com')
        validate_url('mailto:example@puppetlabs.com')
        validate_url('000:111')
        validate_url('http://puppetlabs.com', 'gopher')
        validate_url('http://puppetlabs.com', ['gopher', 'rsync'])
        validate_url([ 'http://puppetlabs.com', 'http://forge.puppetlabs.com' ])
        $undefined = undef
        validate_url($undefined)

    ENDHEREDOC

    unless args.length == 1 or args.length == 2 then
      raise Puppet::ParseError, ("validate_url(): wrong number of arguments (#{args.length}); must be 1 or 2)")
    end

    if (args[1] and not
        (args[1].is_a?(String) or
         (args[1].is_a?(Array) and args[1].reduce(true){|cum, cur| cum and cur.is_a?(String)})))
      raise Puppet::ParseError, ("validate_url(): the second argument must be a string or array of strings")
    end

    begin
      uri = URI::parse(args[0])
    rescue
      raise Puppet::ParseError, ("#{args[0].inspect} is not a valid URL")
    end

    unless uri and uri.host and uri.scheme
      raise Puppet::ParseError, ("#{args[0].inspect} is not a valid URL")
    end

    if args[1]
      schemes = args[1].is_a?(Array) ? args[1] : [args[1]]
      unless schemes.member? uri.scheme
        raise Puppet::ParseError, ("#{args[0].inspect} is not an accepted type of URL")
      end
    end

  end

end
