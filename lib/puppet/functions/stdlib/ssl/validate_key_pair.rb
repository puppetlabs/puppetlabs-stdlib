require 'openssl'
# @summary
#    Validates a PEM-formatted X.509 public_key and private key using
#    OpenSSL. Verifies that the public_key's matches the supplied key.
Puppet::Functions.create_function(:'stdlib::ssl::validate_key_pair') do
  dispatch :validate_ssl_key_pair do
    param 'Stdlib::X509::Pem::Pkey::Public', :public_key
    param 'Stdlib::X509::Pem::Pkey::Private', :private_key
    return_type 'Boolean'
  end
  def validate_ssl_key_pair(public_key, private_key)
    begin
      private_key = OpenSSL::PKey.read(private_key)
    rescue OpenSSL::PKey::PKeyError => error
      raise Puppet::ParseError, "Not a valid Private key: #{error}"
    end
    begin
      public_key = OpenSSL::PKey.read(public_key)
    rescue OpenSSL::PKey::PKeyError => error
      raise Puppet::ParseError, "Not a valid Public key: #{error}"
    end
    if public_key.private?
      raise Puppet::ParseError, "public_key is private: #{error}"
    end
    private_key.public_key.to_der == public_key.to_der
  end
end
