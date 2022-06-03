# @summary validation for pem files
type Stdlib::X509::Pem = Variant[
  Stdlib::X509::Pem::Certificate,
  Stdlib::X509::Pem::Crl,
  Stdlib::X509::Pem::Pkey,
  Stdlib::X509::Pem::Params,
  Stdlib::X509::Pem::Request,
  Stdlib::X509::Pem::Trusted,
]
