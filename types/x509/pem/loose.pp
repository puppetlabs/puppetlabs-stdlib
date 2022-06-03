# @summary a faily loose x509 pem format pattern, just checks of a header and some base64 text
type Stdlib::X509::Pem::Loose = Pattern[
  /\A-{5}BEGIN\s[\w\s]{1,42}-{5}\n(([a-zA-Z0-9\/\+]={,2}){1,64}\n?){1,128}-{5}END\s[\w\s]{1,42}-{5}/
]
