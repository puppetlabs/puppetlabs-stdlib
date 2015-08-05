# Class: hash_resources
#
# hash_resources can help you pass a hash of defined types, built-in
# resources, classes, etc.  This is best used with an ENC.
#
# Parameters
#
# $resources::   A hash of resources
#
# Examples
#
# @example
#  class { 'hash_resources':
#    resources => {
#      'file': {
#        '/tmp/foo': {
#          'ensure'   => 'present',
#          'content' => 'test',
#        },
#        '/tmp/bar': {
#          'ensure'   => 'present',
#          'content' => 'test',
#        }
#      }
#    }
#  }
#
# @example
#  ---
#  classes:
#    hash_resources:
#      resources:
#        file:
#          /tmp/foo:
#            ensure: present
#            content: test
#          /tmp/bar:
#            ensure: present
#            content: test
#
class stdlib::hash_resources(
  $resources = {},
) {

  hash_resources($resources)

}
