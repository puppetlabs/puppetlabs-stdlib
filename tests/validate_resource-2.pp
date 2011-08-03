class foo (
  $a,
  $b,
  $c
  ) {

  validate_resource()

  # ... do something ...

}

class { "foo": 
  a => "1",
  b => "foobaz",
  c => ['a','b','c'] 
}
