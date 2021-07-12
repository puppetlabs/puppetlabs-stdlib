# @summary
#   This function will return the first value in a list of values that is not undefined or an empty string.
#
# @return
#   This function is similar to a coalesce function in SQL in that it will return
#   the first value in a list of values that is not undefined or an empty string
#   If no value is found, it will return the last argument.
#
# @example Allow a global override but fall back to a default
#   $real_jenkins_version = pick_default($::jenkins_version, '1.449')
#
# The value of $real_jenkins_version will first look for a top-scope variable
# called 'jenkins_version' (note that parameters set in the Puppet Dashboard/
# Enterprise Console are brought into Puppet as top-scope variables), and,
# failing that, will use a default value of 1.449.
#
# Contrary to the pick() function, the pick_default does not fail if all
# arguments are empty. This allows pick_default to use an empty value as
# default.
function stdlib::pick_default(
    Array[Any, 1] *$others
) >> Any {
  $filtered = $others.filter |$value| { $value =~ NotUndef and $value != '' }
  if empty($filtered) {
    $others[-1]
  } else {
    $filtered[0]
  }
}
