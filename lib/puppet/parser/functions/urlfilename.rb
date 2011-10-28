require 'uri'

Puppet::Parser::Functions::newfunction(:urlfilename, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|
    Extracts the filename from an url
    
    This function expects one argument, an URL, and returns the name of the file 

    Example:
    $source_filename = urlfilename($source_url)
 
  ENDHEREDOC
  raise ArgumentError, ("urlfilename(): wrong number of arguments (#{args.length}; must be 1)") if args.length != 1
  url=URI.parse args[0]
  File.basename url.path
end

