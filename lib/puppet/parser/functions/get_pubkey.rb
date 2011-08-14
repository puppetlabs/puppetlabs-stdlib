module Puppet::Parser::Functions
  newfunction(:get_pubkey, :type => :rvalue, :doc => <<-EOS
Gets a public key given a CN. This function accepts all the same
parameters as get_certificate(), but instead returns the public
key portion of the certificate.

See get_certificate() for a more complete list of options available.
EOS
  ) do |arguments|

    # Wrap the get_certificate method
    method = Puppet::Parser::Functions.function(:get_certificate)
    cert_text = send(method, arguments)

    require 'openssl'
    
    if cert_text == :undef then
      return :undef
    else
      cert = OpenSSL::X509::Certificate.new(cert_text)
      pubkey = cert.public_key
      return pubkey.to_s
    end
  end
end
