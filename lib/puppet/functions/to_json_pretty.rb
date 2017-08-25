# Take a data structure and output it as pretty JSON
#
# @example how to output pretty JSON
#   # output pretty json to a file
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json_pretty($myhash),
#     }
#
#
require 'json'

Puppet::Functions.create_function(:to_json_pretty) do
  dispatch :to_json_pretty do
    param 'Variant[Hash, Array]', :data
  end

  def to_json_pretty(data)
    JSON.pretty_generate(data)
  end
end
