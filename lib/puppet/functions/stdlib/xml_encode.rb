# frozen_string_literal: true

# @summary Encode strings for XML files
#
# This function can encode strings such that they can be used directly in XML files.
# It supports encoding for both XML text (CharData) or attribute values (AttValue).
Puppet::Functions.create_function(:'stdlib::xml_encode') do
  # @param str The string to encode
  # @param type Whether to encode for text or an attribute
  # @return Returns the encoded CharData or AttValue string suitable for use in XML
  # @example Creating an XML file from a template
  #   file { '/path/to/config.xml':
  #     ensure  => file,
  #     content => epp(
  #       'mymodule/config.xml.epp',
  #       {
  #         password => $password.stdlib::xml_encode,
  #       },
  #     ),
  #   }
  dispatch :xml_encode do
    param 'String', :str
    optional_param "Enum['text','attr']", :type
    return_type 'String'
  end

  def xml_encode(str, type = 'text')
    str.encode(xml: type.to_sym)
  end
end
