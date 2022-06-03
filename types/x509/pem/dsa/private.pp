# @summary x509 DSA private key validation
type Stdlib::X509::Pem::DSA::Private = Pattern[
  /\A-{5}BEGIN\sDSA\sPRIVATE\sKEY-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sDSA\sPRIVATE\sKEY-{5}/
]
