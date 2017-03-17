module Puppet::Parser::Functions                                                                                    

    newfunction(:load_facter, :doc => <<-'ENDHEREDOC') do |args|
        Load a YAML file containing a hash, set the hash values. Support puppet urls

        For example:
        load_facter('/etc/puppet/data/myhash.yaml')
        load_facter('puppet:///modules/name/myhash.yaml')
ENDHEREDOC

        unless args.length == 1
            raise Puppet::ParseError, ("loadyaml(): wrong number of arguments (#{args.length}; must be 1)")
        end

        params = nil
        path = args[0]
        unless Puppet::Util.absolute_path?(path)
            uri = URI.parse(URI.escape(path))
            raise Puppet::ParseError, ("Cannot use relative URLs '#{path}'") unless uri.absolute?
            raise Puppet::ParseError, ("Cannot use opaque URLs '#{path}'") unless uri.hierarchical?
            raise Puppet::ParseError, ("Cannot use URLs of type '#{uri.scheme}' as source for fileserving") unless  %w{puppet}.include?(uri.scheme)
            Puppet.info "loading parameters from #{path}"
            content = Puppet::FileServing::Content.indirection.find(path)
            params = YAML.load(content.content)
        else
            params = YAML.load_file(path)
        end

        params.each do |param, value|
            setvar(param, value)
        end
    end
end
