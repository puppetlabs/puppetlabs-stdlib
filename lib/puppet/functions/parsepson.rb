# frozen_string_literal: true

# @summary
#   This function accepts PSON, a Puppet variant of JSON, as a string and converts
#   it into the correct Puppet structure
#
# @example How to parse pson
#   $data = parsepson('{"a":"1","b":"2"}')
#
# For more information on PSON please see the following link:
# https://puppet.com/docs/puppet/7/http_api/pson.html
#
Puppet::Functions.create_function(:parsepson) do
  # @param pson_string A valid PSON string
  # @param default An optional default to return if parsing the pson_string fails
  # @return [Data]
  dispatch :parsepson do
    param          'String[1]', :pson_string
    optional_param 'Any',       :default
  end

  def parsepson(pson_string, default = :no_default_provided)
    PSON.load(pson_string)
  rescue StandardError => err
    Puppet.debug("Parsing PSON failed with error: #{err.message}")
    raise err if default == :no_default_provided
    default
  end
end
