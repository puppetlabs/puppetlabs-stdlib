# frozen_string_literal: true

require 'json'
# @summary
#   Convert a data structure and output to JSON
#
# @example Output JSON to a file
#   file { '/tmp/my.json':
#     ensure  => file,
#     content => to_json($myhash),
#   }
#
Puppet::Functions.create_function(:to_json) do
  # @param data
  #   Data structure which needs to be converted into JSON
  # @return [String] Converted data to JSON
  dispatch :to_json do
    param 'Any', :data
  end

  def to_json(data)
    data.to_json
  end
end
