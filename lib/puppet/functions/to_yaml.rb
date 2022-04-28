# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert a data structure and output it as YAML
Puppet::Functions.create_function(:to_yaml) do
  # @param data
  #   The data you want to convert to YAML
  # @param options
  #   A hash of options that will be passed to Ruby's Psych library. Note, this could change between Puppet versions, but at time of writing these are `line_width`, `indentation`, and `canonical`.
  #
  # @example Output YAML to a file
  #   file { '/tmp/my.yaml':
  #     ensure  => file,
  #     content => to_yaml($myhash),
  #   }
  # @example Use options to control the output format
  #   file { '/tmp/my.yaml':
  #     ensure  => file,
  #     content => to_yaml($myhash, {indentation => 4})
  #   }
  #
  # @return [String] The YAML document
  dispatch :to_yaml do
    param 'Any', :data
    optional_param 'Hash', :options
  end

  def to_yaml(data, options = {})
    data.to_yaml(options.transform_keys(&:to_sym))
  end
end
