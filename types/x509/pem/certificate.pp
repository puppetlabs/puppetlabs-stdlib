# @summary x509 certificate file
type Stdlib::X509::Pem::Certificate = Pattern[
  /\A-{5}BEGIN\sCERTIFICATE-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sCERTIFICATE-{5}/
]
