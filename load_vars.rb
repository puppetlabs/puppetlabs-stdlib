# vim: set ts=2 sw=2 et :
#
# load_data loads varibles from external yaml file.
# 
# EXAMPLE 1:
# data.yaml:
# --
# host1.client.com:
#   abc: def
#   foo: bar
#   test: other
# host2.client.com:
#   abc: abc
#   foo: baz
#   test: other2
#
# load_vars("/etc/puppet/data.yaml", $fqdn)
# will try to find matching $fqdn key in data.yaml
# and, if found, will add variables $abc $foo and $test
#
#
# EXAMPLE 2:
# data-host1.clent.com.yaml
# abc: def
#
# load_vars("/etc/puppet/data-$fqdn.yaml")
# will add variable $abc

Puppet::Parser::Functions.newfunction :load_vars, :type => :statement do |args|
  file = args[0]
  data = {}
  if args[1]
    key = args[1]
  end

  if FileTest.exist?(file) # file exists

    data = YAML.load_file(file)
    raise ArgumentError, "Data in %s is not a hash" % file unless data.is_a?(Hash)
    # data is a hash for sure

    if key
      # if we have key then use it:
      if data[key].is_a?(Hash)
        data = data[key]
      else
        data = {}
      end
    end

  end
  # add values from hash:
  data.each do |param, value|
    setvar(param, strinterp(value))
  end
end
