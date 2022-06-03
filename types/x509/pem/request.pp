# @summary x509 certificate requst pem validation
type Stdlib::X509::Pem::Request = Pattern[
  /\A-{5}BEGIN\sCERTIFICATE\sREQUEST-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sCERTIFICATE\sREQUEST-{5}/
]
