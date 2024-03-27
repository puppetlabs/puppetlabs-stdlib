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
#   NOTE: functions, such as `template` or `epp`, are not directly evaluated
#         but processed as Puppet code based on epp and erb hash keys.
#
# @example
#   class { 'stdlib::manage':
#     'create_resources'      => {
#       'file'                => {
#         '/etc/motd.d/hello' => {
#           'content'         => 'I say Hi',
#           'notify'          => 'Service[sshd]',
#         },
#         '/etc/motd'         => {
#           'ensure'          => 'file',
#           'epp'             => {
#             'template'      => 'profile/motd.epp',
#           }
#         },
#         '/etc/information'  => {
#           'ensure'          => 'file',
#           'erb'             => {
#             'template'      => 'profile/informaiton.erb',
#           }
#         }
#       },
#       'package'             => {
#         'example'           => {
#           'ensure'          => 'installed',
#           'subscribe'       => ['Service[sshd]', 'Exec[something]'],
#         }
#       }
#     }
#   }
#
# @example
#   stdlib::manage::create_resources:
#     file:
#       '/etc/motd.d/hello':
#         content: I say Hi
#         notify: 'Service[sshd]'
#       '/etc/motd':
#         ensure: 'file'
#         epp:
#           template: 'profile/motd.epp'
#           context: {}
#       '/etc/information':
#         ensure: 'file'
#         erb:
#           template: 'profile/information.erb'
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
      case $type {
        'file': {
          # sanity checks
          # epp, erb and content are exclusive
          if 'epp' in $attributes and 'content' in $attributes {
            fail("You can not set 'epp' and 'content' for file ${title}")
          }
          if 'erb' in $attributes and 'content' in $attributes {
            fail("You can not set 'erb' and 'content' for file ${title}")
          }
          if 'erb' in $attributes and 'epp' in $attributes {
            fail("You can not set 'erb' and 'epp' for file ${title}")
          }

          if 'epp' in $attributes {
            if 'template' in $attributes['epp'] {
              if 'context' in $attributes['epp'] {
                $content = epp($attributes['epp']['template'], $attributes['epp']['context'])
              } else {
                $content = epp($attributes['epp']['template'])
              }
            } else {
              fail("No template configured for epp for file ${title}")
            }
          } elsif 'erb' in $attributes {
            if 'template' in $attributes['erb'] {
              $content = template($attributes['erb']['template'])
            } else {
              fail("No template configured for erb for file ${title}")
            }
          } elsif 'content' in $attributes {
            $content = $attributes['content']
          } else {
            $content = undef
          }
          file { $title:
            *       => $attributes - 'erb' - 'epp' - 'content',
            content => $content,
          }
        }
        default: {
          create_resources($type, { $title => $attributes })
        }
      }
    }
  }
}
