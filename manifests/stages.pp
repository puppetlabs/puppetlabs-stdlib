# Class: stdlib::stages
#
# This class manages a standard set of run stages for Puppet. It is managed by
# the stdlib class, and should not be declared independently.
#
# The high level stages are (in order):
#
#  * setup
#  * main
#  * runtime
#  * setup_infra
#  * deploy_infra
#  * setup_app
#  * deploy_app
#  * deploy
#
# Parameters: none
#
# Actions:
#
#   Declares various run-stages for deploying infrastructure,
#   language runtimes, and application layers.
#
# Requires: nothing
#
# Sample Usage:
#
#  node default {
#    include stdlib
#    class { java: stage => 'runtime' }
#  }
#
class stdlib::stages {

  stage { 'setup': }
  stage { 'runtime': }
  stage { 'setup_infra': }
  stage { 'deploy_infra': }
  stage { 'setup_app': }
  stage { 'deploy_app': }
  stage { 'deploy': }

  Stage[setup] -> Stage[main] -> Stage[runtime]-> Stage[setup_infra] -> Stage[deploy_infra] -> Stage[setup_app] -> Stage[deploy_app] -> Stage[deploy]
}
