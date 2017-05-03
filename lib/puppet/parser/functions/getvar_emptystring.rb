module Puppet::Parser::Functions

  newfunction(:getvar_emptystring, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Lookup a variable in a remote namespace.
    Return an empty string rather than undef/nil if it could not be found

    For example:

        $foo = getvar('site::data::foo')
        # Equivalent to $foo = $site::data::foo

    This is useful if the namespace itself is stored in a string:

        $datalocation = 'site::data'
        $bar = getvar("${datalocation}::bar")
        # Equivalent to $bar = $site::data::bar
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, ("getvar_emptystring(): wrong number of arguments (#{args.length}; must be 1)")
    end

    begin
      result = self.lookupvar("#{args[0]}")

      result = '' if result.nil?

      result
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set and return an empty string
      return ''
    end

  end

end
