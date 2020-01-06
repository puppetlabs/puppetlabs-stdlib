# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# squeeze.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Returns a new string where runs of the same character that occur in this set are replaced by a single character.
#
#    @return
#      a new string where runs of the same character that occur in this set are replaced by a single character.
#
#
Puppet::Functions.create_function(:'stdlib::squeeze') do
  # @param arguments
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :arguments
  end

  def default_impl(*arguments)
    if (arguments.size != 2) && (arguments.size != 1)
      raise(Puppet::ParseError, "squeeze(): Wrong number of arguments given #{arguments.size} for 2 or 1")
    end

    item = arguments[0]
    squeezeval = arguments[1]

    if item.is_a?(Array)
      if squeezeval
        item.map { |i| i.squeeze(squeezeval) }
      else
        item.map { |i| i.squeeze }
      end
    elsif squeezeval
      item.squeeze(squeezeval)
    else
      item.squeeze
    end
  end
end
