# @summary
#   This module manages stdlib.
# 
# Most of stdlib's features are automatically loaded by Puppet, but this class should be 
# declared in order to use the standardized run stages.
# 
# Declares all other classes in the stdlib module. Currently, this consists
# of stdlib::stages and stdlib::manage.
#
class stdlib {
  include stdlib::manage
  include stdlib::stages
}
