# frozen_string_literal: true

# @summary
#   Convert an object into a String containing its Ruby representation
#
# @example how to output Ruby
#   # output Ruby to a file
#   $listen = '0.0.0.0'
#   $port = 8000
#   file { '/opt/acme/etc/settings.rb':
#     content => inline_epp(@("SETTINGS")),
#       LISTEN = <%= $listen.to_ruby %>
#       PORT = <%= $mailserver.to_ruby %>
#       | SETTINGS
#   }

Puppet::Functions.create_function(:to_ruby) do
  # @param object
  #   The object to be converted
  #
  # @return [String]
  #   The String representation of the object
  dispatch :to_ruby do
    param 'Any', :object
  end

  def to_ruby(object)
    serialized = Puppet::Pops::Serialization::ToDataConverter.convert(object, rich_data: true)
    serialized_to_ruby(serialized)
  end

  def serialized_to_ruby(serialized)
    case serialized
    when Array then "[#{serialized.map { |x| serialized_to_ruby(x) }.join(', ')}]"
    when Hash then "{#{serialized.map { |k, v| "#{serialized_to_ruby(k)} => #{serialized_to_ruby(v)}" }.join(', ')}}"
    else serialized.inspect
    end
  end
end
