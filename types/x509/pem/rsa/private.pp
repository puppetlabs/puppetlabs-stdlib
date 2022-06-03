# @summary x509 RSA private key validation
type Stdlib::X509::Pem::RSA::Private = Pattern[
  /\A-{5}BEGIN\sRSA\sPRIVATE\sKEY-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sRSA\sPRIVATE\sKEY-{5}/
]
