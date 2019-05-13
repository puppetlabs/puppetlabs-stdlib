require 'json'
# @summary
#   Convert a data structure and output to JSON
#
# @example how to output JSON
#   # output json to a file
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json($myhash),
#     }
#
Puppet::Functions.create_function(:to_json) do
  # @param data
  #   data structure which needs to be converted into JSON
  # @return converted data to json
  dispatch :to_json do
    param 'Any', :data
  end

  def to_json(data)
    data.to_json
  end
end
