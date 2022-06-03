# @summary x509 DH parameter pem validation
type Stdlib::X509::Pem::DH::Params = Pattern[
  /\A-{5}BEGIN\sDH\sPARAMETERS-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sDH\sPARAMETERS-{5}/
]
