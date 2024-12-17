# This function returns either a rendered template or a deferred function to render at runtime.
# If any of the values in the variables hash are deferred, then the template will be deferred.
#
# Note: In the case where at least some of the values are deferred and preparse is `true` the template
#       is parsed twice:
#  The first parse will evalute any parameters in the template that do not have deferred values.
#  The second parse will run deferred and evaluate only the remaining deferred parameters. Consequently
#  any parameters to be deferred must accept a String[1] in original template so as to accept the value
#  "<%= $variable_with_deferred_value %>" on the first parse.
#
#  @param template template location - identical to epp function template location.
#  @param variables parameters to pass into the template - some of which may have deferred values.
#  @param preparse
#      If `true` the epp template will be parsed twice, once normally and then a second time deferred.
#      It may be nescessary to set `preparse` `false` when deferred values are somethig other than
#      a string
#
function stdlib::deferrable_epp(String $template, Hash $variables, Boolean $preparse = true) >> Variant[String, Sensitive[String], Deferred] {
  if $variables.stdlib::nested_values.any |$value| { $value.is_a(Deferred) } {
    if $preparse {
      $_variables_escaped = $variables.map | $_var , $_value | {
        if $_value.is_a(Deferred) {
          { $_var => "<%= \$${_var} %>" }
        } else {
          { $_var => $_value }
        }
      }.reduce | $_memo, $_kv | { $_memo + $_kv }

      $_template = inline_epp(find_template($template).file,$_variables_escaped)
    } else {
      $_template = find_template($template).file
    }

    Deferred(
      'inline_epp',
      [$_template, $variables],
    )
  }
  else {
    epp($template, $variables)
  }
}
