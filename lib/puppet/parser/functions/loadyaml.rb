module Puppet::Parser::Functions

  newfunction(:loadyaml, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Load a YAML file containing an array, string, or hash, and return the data
    in the corresponding native data type.

    For example:

        $myhash = loadyaml('/etc/puppet/data/myhash.yaml')
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, ("loadyaml(): wrong number of arguments (#{args.length}; must be 1)")
    end

    if Puppet::Util.absolute_path?(args[0])
      file = args[0]
    else
      if args[0] == "" || Puppet::Util.absolute_path?(args[0])
        file = nil
      else
        path, module_file = args[0].split(File::SEPARATOR, 2)
        mod = self.compiler.environment.module(path)
        if module_file && mod
          file = mod.file(module_file)
        else
          file = nil
        end
      end
    end
    YAML.load_file(file)

  end

end
