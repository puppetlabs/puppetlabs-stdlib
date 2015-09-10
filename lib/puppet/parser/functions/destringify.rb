#
# destringify.rb
#
# Loads a fact or other variable, and in case of a stringified fact containing an
# array, string, or hash, it returns the data in the corresponding native data type.
#
# Puppet 3.x will sometimes convert all fact values to strings
# (e.g. "false" instead of false), depending on the stringify_facts setting
# and the installed Facter version.
#
# If you’re writing code that might be used with pre-4.0 versions of Puppet,
# you’ll need to take extra care when dealing with structured facts.
#
# For example:
#
# if the '::processors' fact is stringified as follow:
#   "{\"count\"=>8, \"speed\"=>\"2.7 GHz\"}"
#
#   $my_destringified_processors_fact = destringify(::processors)
#
#   => {"count"=>8, "speed"=>"2.7 GHz"}
#
#
# This could also be done with following puppet/stdlib functions:
#
#   $_fact = $::my_structured_fact
#   if is_string($_fact) {
#     $_yaml = regsubst($_fact,'=>',': ', 'G')
#     $_destringified_fact = parseyaml($_yaml)
#   } else {
#     $_destringified_fact = $_fact
#   }
#
# But using this function it will be reduced to:
#
#   $_destringified_fact = destringify($::my_structured_fact)
#
#

require 'yaml'

module Puppet::Parser::Functions
  newfunction(:destringify, :type => :rvalue, :doc => <<-EOS
Returns hashes, arrays, boolean and integers flattened (stringified) to strings.
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "destringify(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size != 1

    value = arguments[0]

    if value.is_a?(String)
      result = YAML.load(value.gsub( /=>/, ': '))
    else
      result = value
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
