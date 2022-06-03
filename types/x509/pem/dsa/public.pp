# @summary x509 DSA Public key
type Stdlib::X509::Pem::DSA::Public = Pattern[
  /\A-{5}BEGIN\sDSA\sPUBLIC\sKEY-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sDSA\sPUBLIC\sKEY-{5}/
]
