# frozen_string_literal: true

require 'json'

# @summary
#   Convert data structure and output to pretty JSON
#
# @example **Usage**
#   * how to output pretty JSON to file
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => stdlib::to_json_pretty($myhash),
#     }
#
#   * how to output pretty JSON skipping over keys with undef values
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => stdlib::to_json_pretty({
#         param_one => 'value',
#         param_two => undef,
#       }, true),
#     }
#
#   * how to output pretty JSON using tabs for indentation
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => stdlib::to_json_pretty({
#         param_one => 'value',
#         param_two => {
#           param_more => 42,
#         },
#       }, nil, {indent => '    '}),
#     }

Puppet::Functions.create_function(:'stdlib::to_json_pretty') do
  # @param data
  #   data structure which needs to be converted to pretty json
  # @param skip_undef
  #   value `true` or `false`
  # @param opts
  #   hash-map of settings passed to JSON.pretty_generate, see
  #   https://ruby-doc.org/stdlib-2.0.0/libdoc/json/rdoc/JSON.html#method-i-generate.
  #   Note that `max_nesting` doesn't take the value `false`; use `-1` instead.
  # @return
  #   converted data to pretty json
  dispatch :to_json_pretty do
    param 'Variant[Hash, Array]', :data
    optional_param 'Optional[Boolean]', :skip_undef
    optional_param 'Struct[{
indent       => Optional[String],
space        => Optional[String],
space_before => Optional[String],
object_nl    => Optional[String],
array_nl     => Optional[String],
allow_nan    => Optional[Boolean],
max_nesting  => Optional[Integer[-1,default]],
}]', :opts
  end

  def to_json_pretty(data, skip_undef = false, opts = nil)
    # It's not possible to make an abstract type that can be either a boolean
    # false or an integer, so we use -1 as the falsey value
    if opts
      opts = opts.transform_keys(&:to_sym)

      opts[:max_nesting] = false if opts[:max_nesting] == -1
    end

    data = data.compact if skip_undef && (data.is_a?(Array) || Hash)
    call_function('stdlib::rewrap_sensitive_data', data) do |unwrapped_data|
      # Call ::JSON to ensure it references the JSON library from Ruby's standard library
      # instead of a random JSON namespace that might be in scope due to user code.
      ::JSON.pretty_generate(unwrapped_data, opts) << "\n"
    end
  end
end
