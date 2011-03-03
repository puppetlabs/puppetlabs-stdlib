# vim: set ts=2 sw=2 et :
# TODO: path should not be hardcoded here
#
# USAGE:
# $minutes = cronrand("puppet-run", $fqdn, 59)
# file { "puppet-cron":
#   name => /etc/cron.d/puppet-run",
#   content => "$minutes * * * * root /usr/sbin/puppetd --onetime --no-daemonize --logdest syslog > /dev/null 2>&1\n"
# }
# ---
# minutes will be chosen random and saved for each $fqdn,
# second puppet run on same host will create same content as first one.

module Puppet::Parser::Functions
  newfunction(:cronrand, :type => :rvalue) do |args|
    job = args[0]
    host = args[1]
    minutes = (args[2].to_i < 60) ? args[2].to_i : 59
    filename = "/etc/puppet/modules/puppet/state/cronminutes-#{job}-#{host}"
    value = 0

    if FileTest.exists?(filename)
      File.open(filename, 'r') { |fd| value = fd.gets.chomp.to_i }
    else
      value = rand(minutes)
      File.open(filename, 'w') { |fd| fd.puts value }
    end
    value
  end
end

