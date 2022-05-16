# @summary A simple place to define trivial resources
#
# Sometimes your systems require a single simple resource.
# It can feel unnecessary to create a module for a single
# resource.  There are a number of possible patterns to
# generate trivial resource definitions.  This is an attempt
# to create a single clear method for uncomplicated resources.
# There is limited support for `before`, `require`, `notify`,
# and `subscribe`.  However, the target resources must be defined
# before this module is run.
#
# @param create_resources
#   A hash of resources to create
#   NOTE: functions, such as `template` or `epp` are not evaluated.
#
# @example
#   class { 'stdlib::manage':
#       'create_resources' => {
#         'file' => {
#           '/etc/motd.d/hello' => {
#             'content' => 'I say Hi',
#             'notify' => 'Service[sshd]',
#           }
#         },
#         'package' => {
#           'example' => {
#             'ensure' => 'installed',
#           }
#         }
#       }
#
# @example
# stdlib::manage::create_resources:
#   file:
#     '/etc/motd.d/hello':
#       content: I say Hi
#       notify: 'Service[sshd]'
#   package:
#     example:
#       ensure: installed
class stdlib::manage (
  Hash[String, Hash] $create_resources = {}
) {
  $create_resources.each |$type, $resources| {
    $resources.each |$title, $attributes| {
      $filtered_attributes = $attributes.filter |$key, $value| {
        $key !~ /(before|require|notify|subscribe)/
      }

      if $attributes['before'] {
        $_before = stdlib::str2resource($attributes['before'])
      } else {
        $_before = undef
      }

      if $attributes['require'] {
        $_require = stdlib::str2resource($attributes['require'])
      } else {
        $_require = undef
      }

      if $attributes['notify'] {
        $_notify = stdlib::str2resource($attributes['notify'])
      } else {
        $_notify = undef
      }

      if $attributes['subscribe'] {
        $_subscribe = stdlib::str2resource($attributes['subscribe'])
      } else {
        $_subscribe = undef
      }

      create_resources($type, { $title => $filtered_attributes }, { 'before' => $_before, 'require' => $_require, 'notify' => $_notify, 'subscribe' => $_subscribe })
    }
  }
}
