module Puppet::Parser::Functions
  newfunction(:basename, :type => :rvalue, :doc => _(<<-EOS)
    Strips directory (and optional suffix) from a filename
    EOS
  ) do |arguments|

    if arguments.size < 1 then
      raise(Puppet::ParseError, _("basename(): No arguments given"))
    elsif arguments.size > 2 then
      raise(Puppet::ParseError, _("basename(): Too many arguments given (%{num_args})") % { num_args: arguments.size })
    else

      unless arguments[0].is_a?(String)
        raise(Puppet::ParseError, _('basename(): Requires string as first argument'))
      end

      if arguments.size == 1 then
        rv = File.basename(arguments[0])
      elsif arguments.size == 2 then

        unless arguments[1].is_a?(String)
          raise(Puppet::ParseError, _('basename(): Requires string as second argument'))
        end

        rv = File.basename(arguments[0], arguments[1])
      end

    end

    return rv
  end
end

# vim: set ts=2 sw=2 et :
