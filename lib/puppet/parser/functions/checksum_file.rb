require 'puppet/parser/files'
require 'puppet/util/checksums'

module Puppet::Parser::Functions

  newfunction(:checksum_file, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Computes the MD5 checksum for the given file.

    For example:

        $myhash = checksum_file('/etc/puppet/data/myhash.yaml')
    ENDHEREDOC

    unless args.length >= 1
      raise Puppet::ParseError, ("checksum_file(): wrong number of arguments (#{args.length}; must be 1)")
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
    if args.length == 2
      algo = args[1]
    else
      algo = Puppet[:digest_algorithm]
    end
    Puppet::Util::Checksums.method("#{algo}_file").call(file)
  end

end
