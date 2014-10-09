module Puppet::Parser::Functions

  newfunction(:getvar, :type => :rvalue, :arity => 1, :doc => <<-'ENDHEREDOC') do |args|
    Lookup a variable in a remote namespace.

    For example:

        $foo = getvar('site::data::foo')
        # Equivalent to $foo = $site::data::foo

    This is useful if the namespace itself is stored in a string:

        $datalocation = 'site::data'
        $bar = getvar("${datalocation}::bar")
        # Equivalent to $bar = $site::data::bar
    ENDHEREDOC

    begin
      self.lookupvar("#{args[0]}")
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set
    end

  end

end
