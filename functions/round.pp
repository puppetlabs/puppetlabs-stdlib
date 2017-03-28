function stdlib::round(
  Numeric $input,
) {
  if $input >= 0 {
    Integer( $input + 0.5 )
  } else {
    Integer( $input - 0.5 )
  }
}
