# Cron day of week type. Accepts integer, string or an array of integers and/or strings.
#
# The regex matches:
# - Standalone wildcard
# - Integers 0 through 7, without leading zero
# - Day of week abbreviation in place of integers (case insensitive)
# - Ranges (eg. 0-4 or mon-fri)
# - Ranges starting with a wildcard, eg. *-7 (but who would ever use these)
# - Step values 0 through 7 (eg. */5 or 1-4/2, vixie cron)
# - All of the above in comma separated list, eg. 1,3-5
#
# We are not being opinionated on weird syntaxes to keep the validation KISS.
# Eg. Vixie cron accepts a surprising amount of syntax that seems pointless (and
# rightly so) but actually works.
#
# NOTES:
# - 0 and 7 are both Sunday, so 0-6 or 1-7 have the same meaning
# - Should NOT match trailing commas
# - Will not prevent greater numbers preceding smaller ones in ranges
# - Leading zeroes are discouraged because of potential parsing bugs such as:
#   https://tickets.puppetlabs.com/browse/MODULES-7786
#
type Stdlib::Cron::Weekday = Variant[
  Integer[0, 7],
  Pattern[/^(?<everything>(?i)(\*|(?<weekdays>[0-7]|MON|TUE|WED|THU|FRI|SAT|SUN))(-(\g<weekdays>))?(\/(\g<weekdays>))?)(,(\g<everything>))*$/],
  Array[Variant[
    Integer[0, 7],
    Pattern[/^(?<everything>(?i)(\*|(?<weekdays>[0-7]|MON|TUE|WED|THU|FRI|SAT|SUN))(-(\g<weekdays>))?(\/(\g<weekdays>))?)(,(\g<everything>))*$/]
  ], 1]
]
