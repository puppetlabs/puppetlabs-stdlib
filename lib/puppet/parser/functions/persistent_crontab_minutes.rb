#
# persistent_crontab_minutes.rb
#

module Puppet::Parser::Functions
  newfunction(:persistent_crontab_minutes, :type => :rvalue, :doc => <<-EOS
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "Wrong number of arguments " +
      "given (#{arguments.size} for 2)") if arguments.size < 2

    require 'md5'

    value = 0

    job  = arguments[0]
    host = arguments[1]

    environment = Puppet[:environment]

    # We select first directory that exists.  This might not be the best idea ...
    modules = Puppet[:modulepath].split(':').select { |i| File.exists?(i) }.first

    raise(Puppet::ParseError, "Unable to determine the storage " +
      "directory for Puppet modules") unless modules

    # Prepare the file where we store current value ...
    file = "/puppet/state/crontab/#{host}-#{job}.minutes"
    file = File.join(modules, file)

    # Get the directory portion from the file name ...
    directory = File.dirname(file)

    FileUtils.mkdir_p(directory) unless File.directory?(directory)

    if FileTest.exists?(file)
      File.open(file, 'r') { |f| value = f.read.to_i }

      raise(Puppet::ParseError, "The value for minutes in the file `%s' " +
        "is out of the range from 0 to 59 inclusive") unless value < 60
    else
      #
      # Pick a random number based on the job and host name.  This will yield
      # the same value for exactly the same combination of the job and host name.
      #
      value = MD5.new(job_name + host).to_s.hex % 60

      # Minutes are from 0 to 59 inclusive ...
      value = value < 60 ? value : 59

      File.open(file, 'w') { |f| f.write(value) }
    end

    # Tell Puppet to keep an eye on this file ...
    parser = Puppet::Parser::Parser.new(environment)
    parser.watch_file(file) if File.exists?(file)

    return value
  end
end

# vim: set ts=2 sw=2 et :
