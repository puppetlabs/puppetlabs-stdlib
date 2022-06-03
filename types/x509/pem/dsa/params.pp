# @summary x509 DSA parameters pem validation
type Stdlib::X509::Pem::DSA::Params = Pattern[
  /\A-{5}BEGIN\sDSA\sPARAMETERS-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\sDSA\sPARAMETERS-{5}/
]
