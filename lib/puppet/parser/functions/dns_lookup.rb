#
# dns_lookup.rb
#

require 'resolv'

module Puppet::Parser::Functions
  newfunction( :dns_lookup, :type => :rvalue, :doc => <<-EOS
This function takes a list or single element of hostnames and/or ip's,
and returns the list with all hostnames resolved to ip's.

*Examples:*

          dns_lookup(['1.2.3.4','example.com'])

  Returns: ['1.2.3.4','192.0.43.10']

          dns_lookup('1.2.3.4/32','i-dont-exist-domain.com')

  Returns: ['1.2.3.4/32','i-dont-exist-domain.com']

  EOS

  ) do |args|

    unless args.length > 0 then
      raise Puppet::ParseError, ("dns_lookup(): wrong number of arguments (#{args.length}; must be > 0)")
    end

    my_args=args.flatten

    my_args.collect! do |arg|
      if arg =~ /[a-zA-Z]/
        begin
          Resolv.getaddress(arg)
        rescue
          arg
        end
      else
        arg
      end
    end
    return my_args
  end
end

# vim: set ts=2 sw=2 et :
