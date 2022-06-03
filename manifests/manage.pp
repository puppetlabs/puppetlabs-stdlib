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

      create_resources($type, { $title => $filtered_attributes })

      if $attributes['before'] {
        if type($attributes['before'], 'generalized') == 'Array[String]' {
          $attributes['before'].map |$element| { 
            $before_attrib = stdlib::str2resource_attrib($element)
            Resource[$before_attrib['type']] <| title == $before_attrib['title'] |>  <- Resource[$type] <| title == $title |>
          }
        } else {
          $before_attrib = stdlib::str2resource_attrib($attributes['before'])
          Resource[$before_attrib['type']] <| title == $before_attrib['title'] |> <- Resource[$type] <| title == $title |>
        }
      }

      if $attributes['require'] {
        if type($attributes['require'], 'generalized') == 'Array[String]' {
          $attributes['require'].map |$element| { 
            $require_attrib = stdlib::str2resource_attrib($element)
            Resource[$require_attrib['type']] <| title == $require_attrib['title'] |> -> Resource[$type] <| title == $title |>
          }
        } else {
          $require_attrib = stdlib::str2resource_attrib($attributes['require'])
          Resource[$require_attrib['type']] <| title == $require_attrib['title'] |> -> Resource[$type] <| title == $title |>
        }
      }

      if $attributes['notify'] {
        if type($attributes['notify'], 'generalized') == 'Array[String]' {
          $attributes['notify'].map |$element| { 
            $notify_attrib = stdlib::str2resource_attrib($element)
            Resource[$notify_attrib['type']] <| title == $notify_attrib['title'] |> ~> Resource[$type] <| title == $title |>
          }
        } else {
          $attrib = stdlib::str2resource_attrib($attributes['notify'])
          Resource[$notify_attrib['type']] <| title == $notify_attrib['title'] |> ~> Resource[$type] <| title == $title |>
        }
      }

      if $attributes['subscribe'] {
        if type($attributes['subscribe'], 'generalized') == 'Array[String]' {
          $attributes['subscribe'].map |$element| { 
            $subscribe_attrib = stdlib::str2resource_attrib($element)
            Resource[$subscribe_attrib['type']] <| title == $subscribe_attrib['title'] |> <~ Resource[$type] <| title == $title |>
          }
        } else {
          $attrib = stdlib::str2resource_attrib($attributes['subscribe'])
          Resource[$subscribe_attrib['type']] <| title == $subscribe_attrib['title'] |> <~ Resource[$type] <| title == $title |>
        }
      }
    }
  }
}
