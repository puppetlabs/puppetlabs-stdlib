# match DNS RR (DNS SRV) similar to what is described by RFC2782 but is a superset to match real world usage by Freeipa. See https://www.rfc-editor.org/rfc/rfc2782
type Stdlib::Dnssrv = Pattern[/\A(([_a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*(([_a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])\z/]
