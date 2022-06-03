# @summary x509 rsa public key pem validation
type Stdlib::X509::Pem::RSA::Public = Pattern[
  /\A-{5}BEGIN\sRSA\sPUBLIC\sKEY-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sRSA\sPUBLIC\sKEY-{5})/
]
