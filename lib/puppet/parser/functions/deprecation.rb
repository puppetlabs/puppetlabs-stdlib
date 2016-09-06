module Puppet::Parser::Functions
  newfunction(:deprecation, :type => :rvalue, :doc => <<-EOS
  Function to print deprecation warnings (this is the 3.X version of it), The uniqueness key - can appear once. The msg is the message text including any positional information that is formatted by the user/caller of the method.).
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "deprecation: Wrong number of arguments " +
      "given (#{arguments.size} for 2)") unless arguments.size == 2

    key = arguments[0]
    message = arguments[1]
    
    if ENV['STDLIB_LOG_DEPRECATIONS'] == "true"
      caller_infos = caller.first.split(":")
      err_message = "#{message} : #{caller_infos[0]} : #{caller_infos[1]}"
      warning("deprecation. #{key}. #{err_message}")
    end
  end
end
