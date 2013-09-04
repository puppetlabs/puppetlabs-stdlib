module Puppet::Parser::Functions

  newfunction(:loadyaml, :type => :rvalue, :arity => 1, :doc => <<-'ENDHEREDOC') do |args|
    Load a YAML file containing an array, string, or hash, and return the data
    in the corresponding native data type.

    For example:

        $myhash = loadyaml('/etc/puppet/data/myhash.yaml')
    ENDHEREDOC

    YAML.load_file(args[0])

  end

end
