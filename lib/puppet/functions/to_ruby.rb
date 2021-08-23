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
  dispatch :to_ruby do
    param 'Any', :object
  end

  # @param object
  #   The object to be converted
  #
  # @return [String]
  #   The String representation of the object
  def to_ruby(object)
    case object
    when :undef then 'nil'
    when Array then "[#{object.map { |x| to_ruby(x) }.join(', ')}]"
    when Hash then "{#{object.map { |k, v| "#{to_ruby(k)} => #{to_ruby(v)}" }.join(', ')}}"
    else object.inspect
    end
  end
end
