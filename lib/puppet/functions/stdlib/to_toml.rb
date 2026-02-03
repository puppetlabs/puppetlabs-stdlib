# frozen_string_literal: true

require_relative '../../../puppet_x/stdlib/toml_dumper'

# @summary Convert a data structure and output to TOML.
Puppet::Functions.create_function(:'stdlib::to_toml') do
  # @param data Data structure which needs to be converted into TOML
  # @return [String] Converted data as TOML string
  # @example How to output TOML to a file
  #     file { '/tmp/config.toml':
  #       ensure  => file,
  #       content => stdlib::to_toml($myhash),
  #     }
  dispatch :to_toml do
    required_param 'Hash', :data
    return_type 'Variant[String, Sensitive[String]]'
  end

  def to_toml(data)
    call_function('stdlib::rewrap_sensitive_data', data) do |unwrapped_data|
      PuppetX::Stdlib::TomlDumper.new(unwrapped_data).toml_str
    end
  end
end
