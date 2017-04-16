module Puppet::Parser::Functions
  newfunction(:validate_supported_os, :doc => <<-EOT
  EOT
  ) do |args|
    raise(Puppet::ParseError, "validate_supported_os(): Wrong number of arguments, expects one") unless args.size == 1
    mod = args[0]
    module_path = function_get_module_path([mod])
    metadata_json = File.join(module_path, 'metadata.json')

    raise(Puppet::ParseError, "validate_supported_os(): No metadata.json file for module #{mod}") unless File.exists?(metadata_json)

    metadata = PSON.load(File.read(metadata_json))

    operatingsystem = lookupvar('::operatingsystem')
    case lookupvar('::osfamily')
    when 'Debian'
      operatingsystemrelease = lookupvar('::lsbmajdistrelease')
    else
      operatingsystemrelease = lookupvar('::operatingsystemrelease')
    end

    os_support = metadata['operatingsystem_support'].select { |m| m['operatingsystem'] == operatingsystem }
    raise(Puppet::ParseError, "validate_supported_os(): Unsupported OS #{operatingsystem}") if os_support.empty?

    if os_support[0].has_key? 'operatingsystemrelease'
      raise(Puppet::ParseError, "validate_supported_os(): Unsupported OS #{operatingsystem} #{operatingsystemrelease}") unless os_support[0]['operatingsystemrelease'].include? operatingsystemrelease
    end
  end
end
