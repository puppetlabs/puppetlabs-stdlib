# @summary x509 EC private key validation
type Stdlib::X509::Pem::EC::Private = Pattern[
  /\A-{5}BEGIN\sEC\sPRIVATE\sKEY-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sEC\sPRIVATE\sKEY-{5}/
]
