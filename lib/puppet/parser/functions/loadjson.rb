#
# loadjson.rb
#

module Puppet::Parser::Functions
  newfunction(:loadjson, :type => :rvalue, :arity => -2, :doc => <<-'DOC') do |args|
    Load a JSON file containing an array, string, or hash, and return the data
    in the corresponding native data type. The first parameter can be a file paths
    or a URI.
    The second parameter is the default value. It will be returned if the file
    was not found or could not be parsed.

    For example:

        $myhash = loadjson('/etc/puppet/data/myhash.json')
        $myhash = loadjson('https://example.local/my_hash.json')
        $myhash = loadjson('no-file.json', {'default' => 'value'})
  DOC

    raise ArgumentError, 'Wrong number of arguments. 1 or 2 arguments should be provided.' unless args.length >= 1
    require 'open-uri'
    begin
      if args[0].start_with?('http://') || args[0].start_with?('https://')
        contents = open(args[0])
        PSON.load(contents) || args[1]
      elsif File.exists?(args[0]) # rubocop:disable Lint/DeprecatedClassMethods : Changing to .exist? breaks the code
        content = File.read(args[0])
        PSON.load(content) || args[1]
      else
        warning("Can't load '#{args[0]}' File does not exist!")
        args[1]
      end
    rescue Exception => e
      raise e unless args[1]
      args[1]
    end
  end
end
