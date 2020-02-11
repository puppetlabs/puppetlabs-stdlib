#
#    @summary
#      Load a JSON file containing an array, string, or hash, and return the data
#      in the corresponding native data type.
#
#      The first parameter can be a file path or a URL.
#      The second parameter is the default value. It will be returned if the file
#      was not found or could not be parsed.
#
#    @return [Array|String|Hash]
#      The data stored in the JSON file, the type depending on the type of data that was stored.
#
#    @example Example Usage:
#      $myhash = loadjson('/etc/puppet/data/myhash.json')
#      $myhash = loadjson('https://example.local/my_hash.json')
#      $myhash = loadjson('https://username:password@example.local/my_hash.json')
#      $myhash = loadjson('no-file.json', {'default' => 'value'})
#
#
Puppet::Functions.create_function(:'stdlib::loadjson') do
  require 'puppet/util/json'

  # If URL is in the format of https://username:password@example.local/my_info.json
  URI_WITH_NAME_AND_PASS_PATTERN = %r{(http\://|https\://)(.*):(.*)@(.*)}

  # If URL is in the format of https://username@example.local/my_info.json
  URI_WITH_NAME_PATTERN = %r{(http\://|https\://)(.*)@(.*)}

  dispatch :default_impl do
    param 'String', :path_or_uri
    optional_param Any, :default
  end

  def default_impl(path_or_uri, default = nil)
    begin
      if path_or_uri.start_with?('http://', 'https://')
        load_from_uri(path_or_uri, default)

      elsif File.exists?(path_or_uri)
        content = File.read(path_or_uri)

        Puppet::Util::Json.load(content) || default
      else
        warning("Can't load '#{path_or_uri}' File does not exist!")

        default
      end
    rescue StandardError => err
      if default
        default
      else
        raise err
      end
    end
  end

 private
  def load_from_uri(uri, default)
    require 'open-uri'

    username = ''
    password = ''
    if (match = uri.match(URI_WITH_NAME_AND_PASS_PATTERN))
      protocol, username, password, path = match.captures
      url = "#{protocol}#{path}"
    elsif (match = uri.match(URI_WITH_NAME_PATTERN))
      protocol, username, path = match.captures
      url = "#{protocol}#{path}"
    else
      url = uri
    end

    begin
      contents = OpenURI.open_uri(url, :http_basic_authentication => [username, password])
    rescue OpenURI::HTTPError => err
      res = err.io
      warning("Can't load '#{url}' HTTP Error Code: '#{res.status[0]}'")

      default
    end

    Puppet::Util::Json.load(contents) || default
  end
end
