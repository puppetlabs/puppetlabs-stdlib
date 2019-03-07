# Cron minute type. Accepts integer, string or an array of integers and/or strings.
#
# The regex matches:
# - Standalone wildcard
# - Integers 0 through 59, without leading zero
# - Ranges (eg. 0-59)
# - Ranges starting with a wildcard, eg. *-7
# - Step values 1 through 60 (eg. */5 or 0-29/2, vixie cron)
# - All of the above in comma separated list, eg. 0,15,30-35,45
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
type Stdlib::Cron::Minute = Variant[
  Integer[0, 59],
  Pattern[/^(?<everything>(\*|(?<minutes>[0-9]|[1-5][0-9]))(-(\g<minutes>))?(\/([1-9]|[1-5][0-9]|60))?)(,(\g<everything>))*$/],
  Array[Variant[
    Integer[0, 59],
    Pattern[/^(?<everything>(\*|(?<minutes>[0-9]|[1-5][0-9]))(-(\g<minutes>))?(\/([1-9]|[1-5][0-9]|60))?)(,(\g<everything>))*$/]
  ], 1]
]
