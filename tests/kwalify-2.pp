$schema = {
  'type' => 'map',
  'mapping' => {
    'name' => {
      'type' => 'str',
      'required' => true,
    },
    'email' => {
      'type' => 'str',
      'pattern' => '/@/',
    },
    'age' => {
      'type' => 'str',
      'pattern' => '/^\d+$/',
    },
  }
}
$document = {
  'name' => 'foo',
  'email' => 'foo@mail.com',
  'age' => 20,
}

kwalify($schema, $document)
