require 'openssl'
# @summary
#   Extract a public key from a certificate
Puppet::Functions.create_function(:'stdlib::ssl::extract_pkey') do
  def extract_pkey(certificate)
    OpenSSL::X509::Certificate.new(certificate).public_key.to_pem
  end
end
