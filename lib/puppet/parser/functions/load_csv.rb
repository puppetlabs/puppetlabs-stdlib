module Puppet::Parser::Functions
    newfunction(:load_csv, :type => :rvalue, :arity => -2, :doc => <<-'DOC') do |args|
      @summary
        Load a csv file containing an and return the data
        in as an array of arrays
      The first parameter can be a file path or a URL.
      The second parameter is the default value. It will be returned if the file
      was not found or could not be parsed.
      @return [Array]
        The data stored in the CSV file, the as an Array of Arrays
      @example Example Usage:
        $myhash = load_csv('/etc/puppet/data/myhash.json')
        $myhash = load_csv('https://example.local/my_hash.json')
        $myhash = load_csv('https://username:password@example.local/my_hash.json')
        $myhash = load_csv('no-file.json', {'default' => 'value'})
    DOC

      raise ArgumentError, 'Wrong number of arguments. 1 or 2 arguments should be provided.' unless args.length >= 1
      require 'csv'
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
          CSV.parse(contents) || args[1]
        elsif File.exists?(args[0]) # rubocop:disable Lint/DeprecatedClassMethods : Changing to .exist? breaks the code
          content = File.read(args[0])
          CSV.parse(content) || args[1]
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