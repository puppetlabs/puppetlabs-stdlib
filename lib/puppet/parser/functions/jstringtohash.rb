#
# jstringtohash.rb
#

module Puppet::Parser::Functions
  newfunction(:jstringtohash, :type => :rvalue, :doc => <<-EOS
Take a json string object and convert to a hash.
    EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "jstringtohash(): Wrong number of arguments "+
        "given #{arguments.size} for 1")
    end

    value = arguments[0]

    #Puppet::Parser::Functions.function('regsubst')

    if ! value.is_a?(String) then
      raise(Puppet::ParseError, "jstringtohash(): Supply a string only")
    else
      function_parsejson([function_regsubst([value, '=>', ':', 'G'])])
    end

  end
end
