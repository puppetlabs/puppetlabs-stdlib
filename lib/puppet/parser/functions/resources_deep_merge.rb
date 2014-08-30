# Extend for create_resources() merging of the defaults hash, to deep-merge
# hashes. n.b.: stdlib's deep_merge does not.
Puppet::Parser::Functions::newfunction(:resources_deep_merge, :type => :rvalue, :doc => <<-EOS
Returns a deep-merged resource hash (hash of hashes).

Example:
$tcresource_defaults = {
  ensure     => 'present',
  type       => 'javax.sql.DataSource',
  attributes => {
    driverClassName => 'org.postgresql.Driver',
    maxActive       => '20',
    maxIdle         => '10',
    maxWait         => '-1',
    testOnBorrow    => true,
    validationQuery => 'SELECT 1',
  }
}

$tcresources = {
  'app1:jdbc/db1' => {
    attributes => {
      url      => 'jdbc:postgresql://localhost:5432/db1',
      username => 'user1',
      password => 'pass1',
    },
  },
  'app2:jdbc/db2' => {
    attributes => {
      url      => 'jdbc:postgresql://localhost:5432/db2',
      username => 'user2',
      password => 'pass2',
    },
  }
}

$result = resources_deep_merge($tcresources, $tcresource_defaults)

# {
#  'app1:jdbc/db1' => {
#    ensure     => 'present',
#    type       => 'javax.sql.DataSource',
#    attributes => {
#      url      => 'jdbc:postgresql://localhost:5432/db1',
#      username => 'user1',
#      password => 'pass1',
#      driverClassName => 'org.postgresql.Driver',
#      maxActive       => '20',
#      maxIdle         => '10',
#      maxWait         => '-1',
#      testOnBorrow    => true,
#      validationQuery => 'SELECT 1',
#    },
#  },
#  'app2:jdbc/db2' => {
#    ensure     => 'present',
#    type       => 'javax.sql.DataSource',
#    attributes => {
#      url      => 'jdbc:postgresql://localhost:5432/db2',
#      username => 'user2',
#      password => 'pass2',
#      driverClassName => 'org.postgresql.Driver',
#      maxActive       => '20',
#      maxIdle         => '10',
#      maxWait         => '-1',
#      testOnBorrow    => true,
#      validationQuery => 'SELECT 1',
#    },
#  }
# }
EOS
) do |args|
  Puppet::Parser::Functions.function('deep_merge')

  raise ArgumentError, ("resources_deep_merge(): wrong number of arguments (#{args.length} for 2)") if args.length != 2
  resources, defaults = args
  raise ArgumentError, ("resources_deep_merge(): first argument must be a hash")  unless resources.is_a?(Hash)
  raise ArgumentError, ("resources_deep_merge(): second argument must be a hash") unless defaults.is_a?(Hash)

  deep_merged_resources = {}
  resources.each do |title, params|
    deep_merged_resources[title]  = function_deep_merge([defaults, params])
  end

  return deep_merged_resources
end
