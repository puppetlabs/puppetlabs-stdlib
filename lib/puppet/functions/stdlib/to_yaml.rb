# frozen_string_literal: true

require 'yaml'
# @summary
#   Convert a data structure and output it as YAML
Puppet::Functions.create_function(:'stdlib::to_yaml') do
  # @param data
  #   The data you want to convert to YAML
  # @param options
  #   A hash of options that will be passed to Ruby's Psych library. Note, this could change between Puppet versions, but at time of writing these are `line_width`, `indentation`, and `canonical`.
  #
  #   In addition to those, `sort_keys` (Boolean, default `false`) recursively
  #   sorts every Hash's keys so the generated YAML has stable, deterministic
  #   output. Keys of mixed types are ordered by their string form, with ties
  #   broken by the key's Ruby class name; for example the integer `1` sorts
  #   before the string `'1'`, and list (Array) order is always preserved.
  #
  # @example Output YAML to a file
  #   file { '/tmp/my.yaml':
  #     ensure  => file,
  #     content => stdlib::to_yaml($myhash),
  #   }
  # @example Use options to control the output format
  #   file { '/tmp/my.yaml':
  #     ensure  => file,
  #     content => stdlib::to_yaml($myhash, {indentation => 4})
  #   }
  # @example Sort keys for stable output
  #   file { '/tmp/my.yaml':
  #     ensure  => file,
  #     content => stdlib::to_yaml($myhash, {sort_keys => true})
  #   }
  #
  # @return [String] The YAML document
  dispatch :to_yaml do
    param 'Any', :data
    optional_param 'Hash', :options
  end

  def to_yaml(data, options = {})
    call_function('stdlib::rewrap_sensitive_data', data) do |unwrapped_data|
      # 1) build a fresh, mutable hash of options
      #    transform_keys returns a new hash in Ruby 2.5+
      opts = options.transform_keys(&:to_sym)

      # 2) pluck out our custom flag (default false)
      sort_keys = opts.delete(:sort_keys) || false

      # 3) sort if requested
      unwrapped_data = deep_sort(unwrapped_data) if sort_keys

      # 4) dump with the remaining opts
      unwrapped_data.to_yaml(opts)
    end
  end

  private

  def deep_sort(obj)
    case obj
    when Hash
      # sort returns an Array of [k,v], then to_h makes a new Hash
      obj.sort_by { |k, _| [k.to_s, k.class.name] }.to_h { |k, v| [k, deep_sort(v)] }
    when Array
      # preserve list order, but recurse into elements
      obj.map { |item| deep_sort(item) }
    else
      obj
    end
  end
end
