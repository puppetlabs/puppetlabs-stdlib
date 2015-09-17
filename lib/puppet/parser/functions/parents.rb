# Custom Puppet function to return parent directories in a pathname
module Puppet::Parser::Functions
  newfunction(:parents, :type => :rvalue, :arity => 1, :doc => <<-'ENDHEREDOC') do |args|

    Parents will return an array containing all the parent directories of the given pathname, not including the last node in the path.

    It can be very useful to avoid the Puppet error that the parent directory does not exist. For example:

    file {[ parents($install_dir), $install_dir ]:
      ensure => directory,
    }

    ENDHEREDOC

    path_name = args[0]

    if path_name.is_a?(String)
      unless function_validate_absolute_path([path_name])
        raise(Puppet::ParseError, 'parents(): Requires an absolute pathname as an argument')
      end
    else
      raise(Puppet::ParseError, 'parents(): Requires string as argument')
    end

    if path_name =~ /[a-zA-Z]:\\/
      separator = "\\"
    else
      separator = '/'
    end

    item = path_name.split(separator)
    for i in 1..item.length-1 do
      item[i] = "#{item[ i-1 ]}#{separator}#{item[i]}"
    end
    item.shift
    item.pop
    item
  end
end
