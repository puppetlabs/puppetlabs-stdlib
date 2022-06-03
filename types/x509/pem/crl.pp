# @summary x509 CRL pem validation
type Stdlib::X509::Pem::Crl = Pattern[
  /\A-{5}BEGIN\sX509\sCRL-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sX509\sCRL-{5}/
]
