# frozen_string_literal: true

# @summary
#   This function accepts HOCON as a string and converts it into the correct
#   Puppet structure
#
# @param hocon_string can be an actual string of data or a path to a Hocon config file
#
# @param default content that will be returned in case the string isn't parseable
#
# @example How to parse hocon
#   $data = stdlib::parsehocon("{any valid hocon: string}")
#
Puppet::Functions.create_function(:'stdlib::parsehocon') do
  # @param hocon_string A valid HOCON string
  # @param default An optional default to return if parsing hocon_string fails
  # @return [Data]
  dispatch :parsehocon do
    param          'String', :hocon_string
    optional_param 'Any',    :default
  end

  def parsehocon(hocon_string, default = :no_default_provided)
    if File.exist? hocon_string
      require 'hocon'
      Hocon.load(hocon_string)
    else
      require 'hocon/config_factory'
      data = Hocon::ConfigFactory.parse_string(hocon_string)
      data.resolve.root.unwrapped
    end
  rescue Hocon::ConfigError::ConfigParseError => e
    Puppet.debug("Parsing hocon failed with error: #{e.message}")
    raise e if default == :no_default_provided

    default
  end
end
