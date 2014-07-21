$hash1 = {
    'options'   => {
        'ChallengeResponseAuthentication' => 'no',
        'ClientAliveCountMax' => 3,
        'ClientAliveInterval' => 0,
        'Compression' => 'yes',
        'DSAAuthentication' => 'yes',
        'AllowGroups'       => ['somegroup']
    }
}

$hash2 = {
    'options'   => {
        'AllowGroups'   => ['root', 'adm', 'sys']
    }
}

require stdlib

$merged = deep_merge($hash2, $hash1)

notify { 'merged':
    message => inline_template('<% require "pp" -%> <%= PP.pp(@merged) -%> ')
}

$merged2 = deep_merge({'one' => '1', 'two' => '1'}, {'two' => '2', 'three' => '2'})
notify { 'merged2':
    message => inline_template('<% require "pp" -%> <%= PP.pp(@merged2) -%> ')
}
