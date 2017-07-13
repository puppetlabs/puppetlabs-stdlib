module Puppet::Parser::Functions

  newfunction(:getvar, :type => :rvalue, :doc => _(<<-'ENDHEREDOC')) do |args|
    Lookup a variable in a remote namespace.

    For example:

        $foo = getvar('site::data::foo')
        # Equivalent to $foo = $site::data::foo

    This is useful if the namespace itself is stored in a string:

        $datalocation = 'site::data'
        $bar = getvar("${datalocation}::bar")
        # Equivalent to $bar = $site::data::bar
    ENDHEREDOC

    unless args.length == 1
      raise Puppet::ParseError, (_("getvar(): wrong number of arguments (%{num_args}; must be 1)") % { num_args: args.length })
    end

    begin
      result = nil
      catch(:undefined_variable) do
        result = self.lookupvar("#{args[0]}")
      end

      # avoid relying on incosistent behaviour around ruby return values from catch
      result
    rescue Puppet::ParseError # Eat the exception if strict_variables = true is set
    end

  end

end
