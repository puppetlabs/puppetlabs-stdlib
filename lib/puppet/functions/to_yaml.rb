# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert a data structure and output it as YAML
#
# @example How to output YAML
#   # output yaml to a file
#     file { '/tmp/my.yaml':
#       ensure  => file,
#       content => to_yaml($myhash),
#     }
# @example Use options control the output format
#   file { '/tmp/my.yaml':
#     ensure  => file,
#     content => to_yaml($myhash, {indentation: 4})
#   }
Puppet::Functions.create_function(:to_yaml) do
  # @param data
  # @param options
  #
  # @return [String]
  dispatch :to_yaml do
    param 'Any', :data
    optional_param 'Hash', :options
  end

  def to_yaml(data, options = {})
    data.to_yaml(options)
  end
end
