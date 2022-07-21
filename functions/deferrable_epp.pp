# This function returns either a rendered template or a deferred function to render at runtime.
# If any of the values in the variables hash are deferred, then the template will be deferred.
#
# Note: this function requires all parameters to be explicitly passed in. It cannot expect to
# use facts, class variables, and other variables in scope. This is because when deferred, we
# have to explicitly pass the entire scope to the client.
#
function stdlib::deferrable_epp(String $template, Hash $variables) >> Variant[String, Deferred] {
  if $variables.any |$key, $value| { $value.is_a(Deferred) } {
    Deferred(
      'inline_epp',
      [find_template($template).file, $variables],
    )
  }
  else {
    epp($template, $variables)
  }
}
