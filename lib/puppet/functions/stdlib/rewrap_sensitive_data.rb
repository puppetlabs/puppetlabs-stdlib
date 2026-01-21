# frozen_string_literal: true

# @summary Unwraps any sensitives in data and returns a sensitive
#
# It's not uncommon to have Sensitive strings as values within a hash or array.
# Before passing the data to a type property or another function, it's useful
# to be able to `unwrap` these values first. This function does this. If
# sensitive data was included in the data, the whole result is then rewrapped
# as Sensitive.
#
# Optionally, this function can be passed a block. When a block is given, it will
# be run with the unwrapped data, but before the final rewrapping.  This is useful
# to provide transparent rewrapping to other functions in stdlib especially.
#
# This is analogous to the way `epp` transparently handles sensitive parameters.
Puppet::Functions.create_function(:'stdlib::rewrap_sensitive_data') do
  # @param data The data
  # @param block A lambda that will be run after the data has been unwrapped, but before it is rewrapped, (if it contained sensitives)
  # @return Returns the rewrapped data
  dispatch :rewrap_sensitive_data do
    param 'Any', :data
    optional_block_param 'Callable[Any]', :block
    return_type 'Any'
  end

  def rewrap_sensitive_data(data)
    @contains_sensitive = false

    unwrapped = deep_unwrap(data)

    result = block_given? ? yield(unwrapped) : unwrapped

    if @contains_sensitive
      Puppet::Pops::Types::PSensitiveType::Sensitive.new(result)
    else
      result
    end
  end

  def deep_unwrap(obj)
    case obj
    when Hash
      obj.each_with_object({}) do |(key, value), result|
        if key.is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
          # This situation is probably fairly unlikely in reality, but easy enough to support
          @contains_sensitive = true
          key = key.unwrap
        end
        result[key] = deep_unwrap(value)
      end
    when Array
      obj.map { |element| deep_unwrap(element) }
    when Puppet::Pops::Types::PSensitiveType::Sensitive
      @contains_sensitive = true
      deep_unwrap(obj.unwrap)
    else
      obj
    end
  end
end
