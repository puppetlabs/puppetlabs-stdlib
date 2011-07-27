file { '/tmp/dansfile':
  ensure => present
}->
whole_line { 'dans_line':
  line => 'dan is awesome',
  path => '/tmp/dansfile',
}
