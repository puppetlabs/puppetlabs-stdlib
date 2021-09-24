# https://html.spec.whatwg.org/multipage/input.html#valid-e-mail-address
# lint:ignore:140chars
type Stdlib::Email = Pattern[/\A[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/]
# lint:endignore
