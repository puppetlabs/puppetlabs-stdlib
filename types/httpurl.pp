# @summary Validate a HTTP(S) URL
type Stdlib::HTTPUrl = Pattern[/(?i:\Ahttps?:\/\/.*\z)/]
