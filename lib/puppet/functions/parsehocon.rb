# frozen_string_literal: true

# @summary
#   This function accepts HOCON as a string and converts it into the correct
#   Puppet structure
#
# @return
#   Data
#
# @example How to parse hocon
#   $data = parsehocon("{any valid hocon: string}")
#
Puppet::Functions.create_function(:parsehocon) do
  # @param hocon_string A valid HOCON string
  # @param default An optional default to return if parsing hocon_string fails
  dispatch :parsehocon do
    param          'String', :hocon_string
    optional_param 'Any',    :default
  end

  def parsehocon(hocon_string, default = :no_default_provided)
    require 'hocon/config_factory'

    begin
      data = Hocon::ConfigFactory.parse_string(hocon_string)
      data.resolve.root.unwrapped
    rescue Hocon::ConfigError::ConfigParseError => err
      Puppet.debug("Parsing hocon failed with error: #{err.message}")
      raise err if default == :no_default_provided
      default
    end
  end
end
