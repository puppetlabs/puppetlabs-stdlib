module Puppet::Parser::Functions

  newfunction(:loadjson, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Load a JSON file and return it as a native data structure
    For example:

        $myhash = loadjson('/etc/puppet/data/foobar.json')
    ENDHEREDOC
    require 'json'

    unless args.length == 1
      raise Puppet::ParseError, ("loadjson(): wrong number of arguments (#{args.length}; must be 1)")
    end

    fname = args[0]
    if File.exists? fname
      parsed = File.open(fname, "r") do |f|
        JSON.load(f)
      end
      return parsed
    end
    raise Puppet::ParseError, ("loadjson(): No such file #{fname}")
  end
end
