# @summary x509 pem ecdsa public validation
type Stdlib::X509::Pem::ECDSA::Public = Pattern[
  /\A-{5}BEGIN\sECDSA\sPUBLIC\sKEY-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sECDSA\sPUBLIC\sKEY-{5}/
]
