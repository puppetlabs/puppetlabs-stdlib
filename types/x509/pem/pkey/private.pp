# @summary x509 privat ekey pem validation
type Stdlib::X509::Pem::Pkey::Private = Variant[
  Pattern[/(?mx
    \A-{5}BEGIN\sPRIVATE\sKEY-{5}\n
    (([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}
    -{5}END\sPRIVATE\sKEY-{5}
  )/],
  Stdlib::X509::Pem::RSA::Private,
  Stdlib::X509::Pem::DSA::Private,
  Stdlib::X509::Pem::EC::Private,
]
