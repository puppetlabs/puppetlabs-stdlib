module Puppet::Parser::Functions
  newfunction(:dirname, :type => :rvalue, :doc => _(<<-EOS)
    Returns the dirname of a path.
    EOS
  ) do |arguments|

    if arguments.size < 1 then
      raise(Puppet::ParseError, _("dirname(): No arguments given"))
    end
    if arguments.size > 1 then
      raise(Puppet::ParseError, _("dirname(): Too many arguments given (%{num_args})") % { num_args: arguments.size })
    end
    unless arguments[0].is_a?(String)
      raise(Puppet::ParseError, _('dirname(): Requires string as argument'))
    end

    return File.dirname(arguments[0])
  end
end

# vim: set ts=2 sw=2 et :
