# Class to test stdlib validate_legacy function

class test::validate_legacy(
  $type,
  $prev_validation,
  $value,
  $previous_arg1,
  $previous_arg2 = undef,
  ) {

  if $previous_arg2 == undef {
    validate_legacy( $type, $prev_validation, $value, $previous_arg1 )
  } else {
    validate_legacy( $type, $prev_validation, $value, $previous_arg1, $previous_arg2 )
  }
  notice("Success")

}
