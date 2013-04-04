# smoke tests of the function member
#
# puppet apply --noop --modulepath='..' tests/member.pp

include stdlib

$myhash = loadyaml('tests/member.yaml')

info("member([$myhash['array'],'d'):", member(['a','b',$myhash['array']],'d'))
info('member([\'a\',\'b\'],\'c\'):', member(['a','b'],'d'))
