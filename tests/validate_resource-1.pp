define fooresource(
  $color,
  $type,
  $somenumber,
  $map
  ) {

  validate_resource()

  # ... do something ...
 
}

fooresource { "example1":
  color => "blue",
  type => "circle",
  somenumber => 5,
  map => {
    a => 1,
    b => 2,
    c => 3,
  }
}
