module Puppet::Parser::Functions
  newfunction(:loadjson, :type => :rvalue, :arity => -2, :doc => _(<<-'ENDHEREDOC')) do |args|
Load a JSON file containing an array, string, or hash, and return the data
in the corresponding native data type.
The second parameter is the default value. It will be returned if the file
was not found or could not be parsed.

For example:

    $myhash = loadjson('/etc/puppet/data/myhash.json')
    $myhash = loadjson('no-file.json', {'default' => 'value'})
  ENDHEREDOC

    raise ArgumentError, _('Wrong number of arguments. 1 or 2 arguments should be provided.') unless args.length >= 1

    if File.exists?(args[0])
      begin
        content = File.read(args[0])
        PSON::load(content) || args[1]
      rescue Exception => e
        if args[1]
          args[1]
        else
          raise e
        end
      end
    else
      warning(_("Can't load '%{file}' File does not exist!") % { file: args[0], })
      args[1]
    end

  end

end
