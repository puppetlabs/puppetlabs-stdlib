module Puppet::Parser::Functions
  newfunction(:load_module_metadata, :type => :rvalue, :doc => <<-EOT
  EOT
  ) do |args|
    raise(Puppet::ParseError, "load_module_metadata(): Wrong number of arguments, expects one") unless args.size == 1
    mod = args[0]
    module_path = function_get_module_path([mod])
    metadata_json = File.join(module_path, 'metadata.json')

    raise(Puppet::ParseError, "load_module_metadata(): No metadata.json file for module #{mod}") unless File.exists?(metadata_json)

    metadata = PSON.load(File.read(metadata_json))

    return metadata
  end
end
