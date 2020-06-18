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
#       }, true),
#     }
#
#   * how to output pretty JSON using tabs for indentation
#     file { '/tmp/my.json':
#       ensure  => file,
#       content => to_json_pretty({
#         param_one => 'value',
#         param_two => {
#           param_more => 42,
#         },
#       }, nil, {indent => '    '}),
#     }

Puppet::Functions.create_function(:to_json_pretty) do
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
      opts = Hash[opts.map { |k, v| [k.to_sym, v] }]

      if opts[:max_nesting] == -1
        opts[:max_nesting] = false
      end
    end

    if skip_undef
      if data.is_a? Array
        data = data.reject { |value| value.nil? }
      elsif data.is_a? Hash
        data = data.reject { |_, value| value.nil? }
      end
    end
    # Call ::JSON to ensure it references the JSON library from Ruby's standard library
    # instead of a random JSON namespace that might be in scope due to user code.
    ::JSON.pretty_generate(data, opts) << "\n"
  end
end
