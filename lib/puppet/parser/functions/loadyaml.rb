module Puppet::Parser::Functions

  newfunction(:loadyaml, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Load a list of YAML files containing an array, string, or hash, and 
    return the data in the corresponding native data type.

    For example:

        $myhash = loadyaml('/etc/puppet/data/*.yaml', '/etc/myconf/*.yml')
    ENDHEREDOC

    unless args.length >= 1
      raise Puppet::ParseError, ("loadyaml(): wrong number of arguments (#{args.length}; must be >= 1)")
    end

    ret = {}
    args.each do |arg|

      Dir.glob(arg) do |entry|

        ret = ret.merge( YAML.load_file(entry) )

      end

    end
    return ret

  end

end
