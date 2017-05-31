module Puppet::Parser::Functions

  newfunction(:validate_x509_rsa_key_pair, :doc => _(<<-ENDHEREDOC)
    Validates a PEM-formatted X.509 certificate and RSA private key using
    OpenSSL. Verifies that the certficate's signature was created from the
    supplied key.

    Fail compilation if any value fails this check.

    validate_x509_rsa_key_pair($cert, $key)

    ENDHEREDOC
  ) do |args|

    require 'openssl'

    NUM_ARGS = 2 unless defined? NUM_ARGS

    unless args.length == NUM_ARGS then
      raise Puppet::ParseError,
        (_("validate_x509_rsa_key_pair(): wrong number of arguments (%{num_args}; must be %{required})") % { num_args: args.length, required: NUM_ARGS })
    end

    args.each do |arg|
      unless arg.is_a?(String)
        raise Puppet::ParseError, _("%{val} is not a string.") % { val: arg.inspect }
      end
    end

    begin
      cert = OpenSSL::X509::Certificate.new(args[0])
    rescue OpenSSL::X509::CertificateError => e
      raise Puppet::ParseError, _("Not a valid x509 certificate: %{e}") % { e: e }
    end

    begin
      key = OpenSSL::PKey::RSA.new(args[1])
    rescue OpenSSL::PKey::RSAError => e
      raise Puppet::ParseError, _("Not a valid RSA key: %{e}") % { e: e }
    end

    unless cert.verify(key)
      raise Puppet::ParseError, _("Certificate signature does not match supplied key")
    end
  end

end
