# Cron day of month type. Accepts integer, string or an array of integers and/or strings.
#
# The regex matches:
# - Standalone wildcard
# - Integers 1 through 31, without leading zero
# - Ranges (eg. 1-31)
# - Ranges starting with a wildcard, eg. *-7
# - Step values 1 through 31 (eg. */5 or 1-12/2, vixie cron)
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
type Stdlib::Cron::Monthday = Variant[
  Integer[1, 31],
  Pattern[/^(?<everything>(\*|(?<monthdays>[1-9]|[1-2][0-9]|3[0-1]))(-(\g<monthdays>))?(\/(\g<monthdays>))?)(,(\g<everything>))*$/],
  Array[Variant[
    Integer[1, 31],
    Pattern[/^(?<everything>(\*|(?<monthdays>[1-9]|[1-2][0-9]|3[0-1]))(-(\g<monthdays>))?(\/(\g<monthdays>))?)(,(\g<everything>))*$/]
  ], 1]
]
