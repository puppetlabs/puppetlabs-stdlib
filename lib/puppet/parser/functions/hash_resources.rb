# A wrapper to take multiple resources and pass each one to create_resources
module Puppet::Parser::Functions
  newfunction(:hash_resources) do |args|
    hash = args[0]
    raise Puppet::ParserError, "Must provide a hash" unless hash.is_a? Hash

    Puppet::Parser::Functions.autoloader.load(:create_resources) \
      unless Puppet::Parser::Functions.autoloader.loaded?(:create_resources)

    hash.each do |resource, objects|
      function_create_resources([resource, objects])
    end
  end
end
