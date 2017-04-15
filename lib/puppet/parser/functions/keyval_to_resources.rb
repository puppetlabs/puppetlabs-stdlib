module Puppet::Parser::Functions
  newfunction(:keyval_to_resources, :type => :rvalue, :doc => <<-EOS
    Takes a hash of key value pairs and returns a hash structure with
    nested hashes in the style of a resource declaration for use with
    create_resources.  The first argument is the original hash, the
    second argument is the name of the resource attriute to use for the
    values.  For example:

    In hiera:

    module::packages:
      httpd: "2.2.15"
      php: "5.3.1"

    In puppet this is read as
      { "httpd" => "2.2.15", php => "5.3.1" }

    To pass this data to create_resources we need to restructure the
    hash to make the value of each key a hash containing a resource
    attribute and a value, so in this instance

    $resources = keyval_to_resources($hash, 'ensure')

    This gives us:
      { "httpd" => { "ensure" => "2.2.15" }, "php" => { "ensure" => "5.3.1" } }

    And can now be passed to create_resources
      create_resources('package', $resources)

    EOS
  ) do |args|


   raise(ArgumentError, "Wrong number of arguments") if args.size < 2

    kvhash = args[0]
    attribute = args[1]

    raise(ArgumentError, "Not a hash") unless kvhash.is_a?(Hash)


    rhash = {}
    kvhash.each { |k,v| rhash.merge!({k => { attribute => v }}) }
    rhash
  end
end

