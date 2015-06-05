module Puppet::Parser::Functions

  newfunction(:getvar, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Lookup a variable in a remote namespace.

    For example:

        $foo = getvar('site::data::foo')
        # Equivalent to $foo = $site::data::foo

    This is useful if the namespace itself is stored in a string:

        $datalocation = 'site::data'
        $bar = getvar("${datalocation}::bar")
        # Equivalent to $bar = $site::data::bar
    ENDHEREDOC

    if args.length > 2 or args.length < 1
      raise Puppet::ParseError, ("getvar(): wrong number of arguments (#{args.length}; must be 1)")
    end

    begin
      getvar = self.lookupvar("#{args[0]}")
      if getvar != nil ; then
        getvar
      elsif args[1] != nil
        args[1]
      end
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set
      # Return the requested default if provided
      if args[1] != nil; then
        return args[1]
      end
    end

  end

end
