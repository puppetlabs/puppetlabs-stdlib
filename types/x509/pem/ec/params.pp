# @summary x509 ec params pem validation
type Stdlib::X509::Pem::EC::Params = Pattern[
  /\A-{5}BEGIN\sEC\sPARAMETERS-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sEC\sPARAMETERS-{5}/
]
