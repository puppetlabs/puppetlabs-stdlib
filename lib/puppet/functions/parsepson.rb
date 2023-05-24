# frozen_string_literal: true

# @summary
#   **Deprecated:** Starting Puppet 8, we no longer natively support PSON usage. This function should be removed once we stop supporting Puppet 7.
#
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
    call_function('deprecation', 'parsepson', 'This method is deprecated. From Puppet 8, PSON is no longer natively supported. Please use JSON.parse().')

    PSON.load(pson_string) if Puppet::Util::Package.versioncmp(Puppet.version, '8').negative?
  rescue StandardError => e
    Puppet.debug("Parsing PSON failed with error: #{e.message}")
    raise e if default == :no_default_provided

    default
  end
end
