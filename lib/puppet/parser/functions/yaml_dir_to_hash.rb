module Puppet::Parser::Functions
  newfunction(:yaml_dir_to_hash, :type => :rvalue) do |args|
    args[0] =~ /^puppet:\/\/\/modules\/([^\/]+)\/(.*)$/
    path = "#{Puppet::Module.find($1, compiler.environment.to_s).path}/#{$2}"
    Hash[
      Dir.entries(path).collect do |file|
        next unless file =~ /\.y(a?)ml$/
        name = file.gsub('.yaml', '')
        [name, YAML::load_file("#{path}#{file}")]
      end.compact
    ]
  end
end
