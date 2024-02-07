# @summary This function is deprecated. It implements the functionality of the original non-namespaced stdlib `time` function.
#
# It is provided for compatability, but users should use the native time related functions directly.
#
# @param _timezone
#   This parameter doesn't do anything, but exists for compatability reasons
function stdlib::time(Optional[String] $_timezone = undef) >> Integer {
  # Note the `timezone` parameter doesn't do anything and didn't in the ruby implementation for _years_ (pre 1.8.7 perhaps ???)
  deprecation('time', 'The stdlib `time` function is deprecated. Please direcly use native Puppet functionality instead. eg. `Integer(Timestamp().strftime(\'%s\'))`', false)
  Integer(Timestamp().strftime('%s'))
}
