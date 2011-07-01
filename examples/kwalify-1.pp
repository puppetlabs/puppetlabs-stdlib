$schema = {
  'type' => 'seq',
  'sequence' => [
    { 'type' => 'str', 'enum' => ['asdf','fdsa'] }
  ]
}
$document = ['a', 'b', 'c']

kwalify($schema, $document)
