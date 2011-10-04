module Puppet::Parser::Functions
  newfunction(:get_certificate, :type => :rvalue, :doc => <<-EOS
Returns the public certificate of the given CN from the local or remote Puppet
CA.

Usage is:

    get_certificate($cn, $options)

The first argument $cn is a valid CN for the certificate you wish to
return. A CN is usually the hostname of a machine in Puppet. You can view all available
certificates using the facility:

    puppet cert --list --all

On the main CA or puppetmaster.

The second argument $options allows the user to define a hash of options to
pass to the function.

The options and descriptions are:

* *conn_timeout*: Adjust timeout for remote CA connectivity (in seconds). Default is 7.
  EOS
  ) do |arguments|

    # Make sure we have enough arguments
    if not (1..2).include?(arguments.size) then
      raise(Puppet::ParseError, "get_certificate(): Wrong number of arguments " +
        "given (#{arguments.size} for 1 or 2)")
    end

    # Obtain arguments and set defaults
    cn = arguments[0]
    options = arguments[1] ||= {}
    options[:conn_timeout] = 7 if !options.has_key?(:conn_timeout)

    # Validation of arguments
    if not (cn.is_a?(String) and cn.match(/^[a-zA-Z0-9@_\-\.]+$/)) then
      raise(Puppet::ParseError, 'get_certificate(): CN name must be a valid string. Hashes and Arrays are not valid')
    end
    if not (1..600).include?(options[:conn_timeout]) then
      raise(Puppet::ParseError, "get_certificate(): The option 'conn_timeout' must be an integer between 1 and 600")
    end
  
    # Get and return certificate using file or rest
    if Puppet[:ca] == true then
      # Get the certificate locally if we are acting as a CA
      # TODO: wrap: puppet certificate --render-as s --ca-location remote find ken@bob.sh
      ssl_cert_path = Puppet[:signeddir] + "/" + cn + ".pem"
      if FileTest.exists?(ssl_cert_path) then
        cert = File.open(ssl_cert_path,"r")
        return cert.read
      end
    else
      # Obtain the certificate from the CA if its remote
      # TODO: wrap: puppet certificate --render-as s --ca-location local find ken@bob.sh
      require 'net/http'
      require 'net/https'

      http = Net::HTTP.new(Puppet[:ca_server], Puppet[:ca_port])
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      begin
        res = timeout(options[:conn_timeout]) do
          http.start {|h|
            h.get("/production/certificate/#{cn}", { "Accept" => "s" })
          }
        end
      rescue Timeout::Error
        raise(Puppet::Error, "Transaction timed out when connecting to #{Puppet[:ca_server]}:#{Puppet[:ca_port]}. Check your CA is running and that your ca_server and ca_port settings are correct on the machine this function ran on.")
      rescue Errno::ECONNREFUSED
        raise(Puppet::Error, "Connection refused when connecting to #{Puppet[:ca_server]}:#{Puppet[:ca_port]}. Check your CA is running and that your ca_server and ca_port settings are correct on the machine this function ran on.")
      end

      case res.code
      when "200"
        return res.body if res.body
      when "404"
        return :undef
      else 
        raise(Puppet::Error, "Error with REST call: #{res.code}")
      end
    end

    :undef
  end
end
