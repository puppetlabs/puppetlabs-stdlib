module Puppet::Parser::Functions
  newfunction(:ensure_latest, :type => :statement, :doc => <<-EOS
Takes a list of packages and only installs them if they don't already exist.
It optionally takes a hash as a second parameter to be passed as the third
argument to the ensure_resource() function. By contrast to the
ensure_packages() function, this function installs packages with
ensure=>'latest' by default.
    EOS
  ) do |arguments|

    if arguments.size > 2 or arguments.size == 0
      raise(Puppet::ParseError, "ensure_latest(): Wrong number of arguments " +
        "given (#{arguments.size} for 1 or 2)")
    elsif arguments.size == 2 and !arguments[1].is_a?(Hash)
      raise(Puppet::ParseError, 'ensure_latest(): Requires second argument to be a Hash')
    end

    if arguments[1]
      defaults = { 'ensure' => 'latest' }.merge(arguments[1])
    else
      defaults = { 'ensure' => 'latest' }
    end

    Puppet::Parser::Functions.function(:ensure_packages)
    function_ensure_packages([arguments[0], defaults])
  end
end
