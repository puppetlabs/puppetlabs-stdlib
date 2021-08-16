# frozen_string_literal: true

# @summary
#   Convert an object into a String containing its Python representation
#
# @example how to output Python
#   # output Python to a file
#   $listen = '0.0.0.0'
#   $port = 8000
#   file { '/opt/acme/etc/settings.py':
#     content => inline_epp(@("SETTINGS")),
#       LISTEN = <%= $listen.to_python %>
#       PORT = <%= $mailserver.to_python %>
#       | SETTINGS
#   }

Puppet::Functions.create_function(:to_python) do
  dispatch :to_python do
    param 'Any', :object
  end

  # @param object
  #   The object to be converted
  #
  # @return [String]
  #   The String representation of the object
  def to_python(object)
    case object
    when true then 'True'
    when false then 'False'
    when :undef then 'None'
    when Array then "[#{object.map { |x| to_python(x) }.join(', ')}]"
    when Hash then "{#{object.map { |k, v| "#{to_python(k)}: #{to_python(v)}" }.join(', ')}}"
    else object.inspect
    end
  end
end
