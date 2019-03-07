# Cron month type. Accepts integer, string or an array of integers and/or strings.
#
# The regex matches:
# - Standalone wildcard
# - Integers 1 through 12, without leading zero
# - Month abbreviation in place of integers (case insensitive)
# - Ranges (eg. 1-12 or jan-jun)
# - Ranges starting with a wildcard, eg. *-7
# - Step values 1 through 12 (eg. */5 or 1-12/2, vixie cron)
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
type Stdlib::Cron::Month = Variant[
  Integer[1, 12],
  Pattern[/^(?<everything>(?i)(\*|(?<months>[1-9]|1[0-2]|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))(-(\g<months>))?(\/(\g<months>))?)(,(\g<everything>))*$/],
  Array[Variant[
    Integer[1, 12],
    Pattern[/^(?<everything>(?i)(\*|(?<months>[1-9]|1[0-2]|JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC))(-(\g<months>))?(\/(\g<months>))?)(,(\g<everything>))*$/]
  ], 1]
]
