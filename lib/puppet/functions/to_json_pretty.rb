require 'json'
# @summary
#   Convert data structure and output to pretty JSON
#
# @example **Usage**
#   * how to output pretty JSON to file
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json_pretty($myhash),
#     }
#
#   * how to output pretty JSON skipping over keys with undef values
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json_pretty({
#         param_one => 'value',
#         param_two => undef,
#       }),
#     }
Puppet::Functions.create_function(:to_json_pretty) do
  # @param data
  #   data structure which needs to be converted to pretty json
  # @param skip_undef
  #   value `true` or `false`
  # @return
  #   converted data to pretty json
  dispatch :to_json_pretty do
    param 'Variant[Hash, Array]', :data
    optional_param 'Boolean', :skip_undef
  end

  def to_json_pretty(data, skip_undef = false)
    if skip_undef
      if data.is_a? Array
        data = data.reject { |value| value.nil? }
      elsif data.is_a? Hash
        data = data.reject { |_, value| value.nil? }
      end
    end
    JSON.pretty_generate(data) << "\n"
  end
end
