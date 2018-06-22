#
# loadjson.rb
#

module Puppet::Parser::Functions
  newfunction(:loadjson, :type => :rvalue, :arity => -2, :doc => <<-'DOC') do |args|
    Load a JSON file containing an array, string, or hash, and return the data
    in the corresponding native data type.
    The first parameter can be a file path or a URL.
    The second parameter is the default value. It will be returned if the file
    was not found or could not be parsed.

    For example:

        $myhash = loadjson('/etc/puppet/data/myhash.json')
        $myhash = loadjson('https://example.local/my_hash.json')
        $myhash = loadjson('https://username:password@example.local/my_hash.json')
        $myhash = loadjson('no-file.json', {'default' => 'value'})
  DOC

    raise ArgumentError, 'Wrong number of arguments. 1 or 2 arguments should be provided.' unless args.length >= 1
    require 'open-uri'
    begin
      if args[0].start_with?('http://', 'https://')
        username = ''
        password = ''
        if (match = args[0].match(%r{(http\://|https\://)(.*):(.*)@(.*)}))
          # If URL is in the format of https://username:password@example.local/my_hash.yaml
          protocol, username, password, path = match.captures
          url = "#{protocol}#{path}"
        elsif (match = args[0].match(%r{(http\:\/\/|https\:\/\/)(.*)@(.*)}))
          # If URL is in the format of https://username@example.local/my_hash.yaml
          protocol, username, path = match.captures
          url = "#{protocol}#{path}"
        else
          url = args[0]
        end
        begin
          contents = OpenURI.open_uri(url, :http_basic_authentication => [username, password])
        rescue OpenURI::HTTPError => err
          res = err.io
          warning("Can't load '#{url}' HTTP Error Code: '#{res.status[0]}'")
          args[1]
        end
        PSON.load(contents) || args[1]
      elsif File.exists?(args[0]) # rubocop:disable Lint/DeprecatedClassMethods : Changing to .exist? breaks the code
        content = File.read(args[0])
        PSON.load(content) || args[1]
      else
        warning("Can't load '#{args[0]}' File does not exist!")
        args[1]
      end
    rescue StandardError => e
      raise e unless args[1]
      args[1]
    end
  end
end
