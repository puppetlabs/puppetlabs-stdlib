# Type to match base32 String
type Stdlib::Base32 = Pattern[/\A[a-z2-7]+={,6}\z/, /\A[A-Z2-7]+={,6}\z/]
