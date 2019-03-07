# Cron hour type. Accepts integer, string or an array of integers and/or strings.
#
# The regex matches:
# - Standalone wildcard
# - Integers 0 through 23, without leading zero
# - Ranges (eg. 0-23)
# - Ranges starting with a wildcard, eg. *-7
# - Step values 1 through 24 (eg. */5 or 0-12/2, vixie cron)
# - All of the above in comma separated list, eg. 1,3,7-9
#
# We are not being opinionated on weird syntaxes to keep the validation KISS.
# Eg. Vixie cron accepts a surprising amount of syntax that seems pointless (and
# rightly so) but actually works.
#
# NOTES:
# - Should NOT match trailing commas
# - Will not prevent greater numbers preceding smaller ones in ranges
# - Leading zeroes are discouraged because of potential parsing bugs such as:
#   https://tickets.puppetlabs.com/browse/MODULES-7786
#
type Stdlib::Cron::Hour = Variant[
  Integer[0, 23],
  Pattern[/^(?<everything>(\*|(?<hours>[0-9]|1[0-9]|2[0-3]))(-(\g<hours>))?(\/([1-9]|1[0-9]|2[0-4]))?)(,(\g<everything>))*$/],
  Array[Variant[
    Integer[0, 23],
    Pattern[/^(?<everything>(\*|(?<hours>[0-9]|1[0-9]|2[0-3]))(-(\g<hours>))?(\/([1-9]|1[0-9]|2[0-4]))?)(,(\g<everything>))*$/]
  ], 1]
]
