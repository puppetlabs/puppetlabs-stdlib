# frozen_string_literal: true

# @summary
#   Load a JSON file containing an array, string, or hash, and return the data
#   in the corresponding native data type.
#
# @example Example Usage:
#   $myhash = loadjson('/etc/puppet/data/myhash.json')
#   $myhash = loadjson('https://example.local/my_hash.json')
#   $myhash = loadjson('https://username:password@example.local/my_hash.json')
#   $myhash = loadjson('no-file.json', {'default' => 'value'})
Puppet::Functions.create_function(:'stdlib::loadjson') do
  # @param path
  #   A file path or a URL.
  # @param default
  #   The default value to be returned if the file was not found or could not
  #   be parsed.
  #
  # @return
  #   The data stored in the JSON file, the type depending on the type of data
  #   that was stored.
  dispatch :loadjson do
    param 'String[1]', :path
    optional_param 'Data', :default
    return_type 'Data'
  end

  def loadjson(path, default = nil)
    if path.start_with?('http://', 'https://')
      require 'uri'
      require 'open-uri'
      uri = URI.parse(path)
      options = {}
      if uri.user
        options[:http_basic_authentication] = [uri.user, uri.password]
        uri.user = nil
      end

      begin
        content = uri.open(**options) { |f| load_json_source(f) }
      rescue OpenURI::HTTPError => e
        Puppet.warn("Can't load '#{url}' HTTP Error Code: '#{e.io.status[0]}'")
        return default
      end
    elsif File.exist?(path)
      content = File.open(path) { |f| load_json_source(f) }
    else
      Puppet.warn("Can't load '#{path}' File does not exist!")
      return default
    end

    content || default
  rescue StandardError => e
    raise e unless default

    default
  end

  def load_json_source(source)
    if Puppet::Util::Package.versioncmp(Puppet.version, '8.0.0').negative?
      PSON.load(source)
    else
      JSON.load(source)
    end
  end
end
