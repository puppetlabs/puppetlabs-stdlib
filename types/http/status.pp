# @summary A valid HTTP status code per RFC9110
# @see https://httpwg.org/specs/rfc9110.html#overview.of.status.codes
type Stdlib::Http::Status = Integer[100, 599]
