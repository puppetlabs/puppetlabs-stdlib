#
# dig.rb
#

module Puppet::Parser::Functions
  newfunction(:dig, :type => :rvalue, :doc => <<-EOS
Deep lookup in nested hash. Returns nil or provided
default value if path can't be looked up.
    EOS
             ) do |arguments|
    # Two arguments are required
    raise(Puppet::ParseError, "dig(): Wrong number of arguments " +
                              "given (#{arguments.size} for at least 2)") if arguments.size < 2

    hash, path, default = *arguments

    unless hash.is_a? Hash
      raise(Puppet::ParseError, "dig(): first argument must be hash, " <<
                                "given #{hash.class.name}")
    end

    unless path.is_a? Array
      raise(Puppet::ParseError, "dig(): second argument must be an array, " <<
                                "given #{path.class.name}")
    end

    value = path.reduce(hash) { |h, k| h[k] if h.is_a?(Hash) }
    value.nil? ? default : value
  end
end

# vim: set ts=2 sw=2 et :
