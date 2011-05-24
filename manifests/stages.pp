# Class: stdlib::stages
#
# This class manages a standard set of Run Stages for Puppet.
#
# The high level stages are (In order):
#
#  * setup
#  * deploy
#  * runtime
#  * setup_infra
#  * deploy_infra
#  * main
#  * setup_app
#  * deploy_app
#
# Parameters:
#
# Actions:
#
#   Declares various run-stages for deploying infrastructure,
#   language runtimes, and application layers.
#
# Requires:
#
# Sample Usage:
#
#  node default {
#    include stdlib::stages
#    class { java: stage => 'runtime' }
#  }
#
class stdlib::stages {

  stage { 'setup':  before => Stage['deploy'] }
  stage { 'deploy': before => Stage['setup_infra'] }
  stage { 'runtime':
    require => Stage['deploy'],
    before  => Stage['setup_infra'],
  }
  stage { 'setup_infra':  before  => Stage['deploy_infra'] }
  stage { 'deploy_infra': before  => Stage['main'] }
  stage { 'setup_app':    require => Stage['main'] }
  stage { 'deploy_app':   require => Stage['setup_app'] }

}
