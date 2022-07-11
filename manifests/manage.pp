# @summary A simple place to define trivial resources
#
# Sometimes your systems require a single simple resource.
# It can feel unnecessary to create a module for a single
# resource.  There are a number of possible patterns to
# generate trivial resource definitions.  This is an attempt
# to create a single clear method for uncomplicated resources.
# There is __limited__ support for `before`, `require`, `notify`,
# and `subscribe`.
#
# @param create_resources
#   A hash of resources to create
#   NOTE: functions, such as `template` or `epp`, are not evaluated.
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
#             'subscribe' => ['Service[sshd]', 'Exec[something]'],
#           }
#         }
#       }
#
# @example
#   stdlib::manage::create_resources:
#     file:
#       '/etc/motd.d/hello':
#         content: I say Hi
#         notify: 'Service[sshd]'
#     package:
#       example:
#         ensure: installed
#         subscribe:
#           - 'Service[sshd]'
#           - 'Exec[something]'
class stdlib::manage (
  Hash[String, Hash] $create_resources = {}
) {
  $create_resources.each |$type, $resources| {
    $resources.each |$title, $attributes| {
      create_resources($type, { $title => $attributes })
    }
  }
}
