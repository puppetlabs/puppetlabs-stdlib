# Class: stdlib::spool
#
#   This class manages a standard base directory location for use in file fragment
# patterns.
#
# Default location is $vardir/spool
#
# == Parameters
#
# [*basedir*]
#   This parameter sets the base directory location for file fragments.  Defaults
# to $vardir.
#
# == Examples
#
#  node default {
#    class { 'stdlib::spool':
#      basedir => '/var/lib/puppet'
#    }
#  }
#
class stdlib::spool($basedir = $::vardir) {

  file { "${basedir}/spool":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
}
