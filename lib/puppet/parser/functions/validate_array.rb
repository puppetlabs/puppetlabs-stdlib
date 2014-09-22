module Puppet::Parser::Functions

  newfunction(:validate_array, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are array data structures. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $my_path = 'C:/Program Files (x86)/Puppet Labs/Puppet'
        validate_absolute_path($my_path)
        $my_path2 = '/var/lib/puppet'
        validate_absolute_path($my_path2)
        $my_path3 = ['C:/Program Files (x86)/Puppet Labs/Puppet','C:/Program Files/Puppet Labs/Puppet']
        validate_absolute_path($my_path3)
        $my_path4 = ['/var/lib/puppet','/usr/share/puppet']
        validate_absolute_path($my_path4)


    The following values will fail, causing compilation to abort:

        validate_absolute_path(true)
        validate_absolute_path('../var/lib/puppet')
        validate_absolute_path('var/lib/puppet')
        validate_absolute_path([ 'var/lib/puppet', '/var/foo' ])
        validate_absolute_path([ '/var/lib/puppet', 'var/foo' ])
        $undefined = undef
        validate_absolute_path($undefined)

    ENDHEREDOC

    unless args.length > 0 then
      raise Puppet::ParseError, ("validate_array(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    args.each do |arg|
      unless arg.is_a?(Array)
        raise Puppet::ParseError, ("#{arg.inspect} is not an Array.  It looks to be a #{arg.class}")
      end
    end

  end

end
