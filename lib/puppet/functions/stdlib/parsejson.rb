#
#    @summary
#      This function accepts JSON as a string and converts it into the correct
#      Puppet structure.
#
#    @return
#      convert JSON into Puppet structure
#
#    > *Note:*
#      The optional second argument can be used to pass a default value that will
#      be returned if the parsing of JSON string have failed.
#
#
Puppet::Functions.create_function(:'stdlib::parsejson') do

  dispatch :default_impl do
    param 'String', :json_string
    optional_param 'Any', :default
  end

  def default_impl(json_string, default = nil)
    require 'puppet/util/json'

    begin
      Puppet::Util::Json.load(json_string) || default
    rescue StandardError => err
      if default
        default
      else
        raise err
      end
    end
  end
end
