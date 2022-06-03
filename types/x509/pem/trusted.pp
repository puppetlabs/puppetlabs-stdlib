# @summary x509 trusted certificate pem validation
type Stdlib::X509::Pem::Trusted = Pattern[
  /\A-{5}BEGIN\sTRUSTED\sCERTIFICATE-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sTRUSTED\sCERTIFICATE-{5}/
]
