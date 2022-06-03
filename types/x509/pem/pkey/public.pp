# @summary x509 public key pem validation
type Stdlib::X509::Pem::Pkey::Public = Variant[
  Pattern[/(?mx
    \A-{5}BEGIN\sPUBLIC\sKEY-{5}\n
    (([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}
    -{5}END\sPUBLIC\sKEY-{5}
  )/],
  Stdlib::X509::Pem::RSA::Public,
  Stdlib::X509::Pem::DSA::Public,
  Stdlib::X509::Pem::ECDSA::Public,
]
