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
  # @param object
  #   The object to be converted
  #
  # @return [String]
  #   The String representation of the object
  dispatch :to_python do
    param 'Any', :object
  end

  def to_python(object)
    serialized = Puppet::Pops::Serialization::ToDataConverter.convert(object, rich_data: true)
    serialized_to_python(serialized)
  end

  def serialized_to_python(serialized)
    case serialized
    when true then 'True'
    when false then 'False'
    when nil then 'None'
    when Array then "[#{serialized.map { |x| serialized_to_python(x) }.join(', ')}]"
    when Hash then "{#{serialized.map { |k, v| "#{serialized_to_python(k)}: #{serialized_to_python(v)}" }.join(', ')}}"
    else serialized.inspect
    end
  end
end
