# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# is_absolute_path.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      **Deprecated:** Returns boolean true if the string represents an absolute path in the filesystem.
#
#    This function works for windows and unix style paths.
#
#    @example The following values will return true:
#      $my_path = 'C:/Program Files (x86)/Puppet Labs/Puppet'
#      is_absolute_path($my_path)
#      $my_path2 = '/var/lib/puppet'
#      is_absolute_path($my_path2)
#      $my_path3 = ['C:/Program Files (x86)/Puppet Labs/Puppet']
#      is_absolute_path($my_path3)
#      $my_path4 = ['/var/lib/puppet']
#      is_absolute_path($my_path4)
#
#    @example The following values will return false:
#      is_absolute_path(true)
#      is_absolute_path('../var/lib/puppet')
#      is_absolute_path('var/lib/puppet')
#      $undefined = undef
#      is_absolute_path($undefined)
#
#    @return [Boolean]
#      Returns `true` or `false`
#
#    > **Note:* **Deprecated** Will be removed in a future version of stdlib. See
#    [`validate_legacy`](#validate_legacy).
#
#
Puppet::Functions.create_function(:'stdlib::is_absolute_path') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end

  def default_impl(*args)
    function_deprecation([:is_absolute_path, 'This method is deprecated, please use the stdlib validate_legacy function,
                           with Stdlib::Compat::Absolute_path. There is further documentation for validate_legacy function in the README.'])
    require 'puppet/util'

    path = args[0]
    # This logic was borrowed from
    # [lib/puppet/file_serving/base.rb](https://github.com/puppetlabs/puppet/blob/master/lib/puppet/file_serving/base.rb)
    # Puppet 2.7 and beyond will have Puppet::Util.absolute_path? Fall back to a back-ported implementation otherwise.
    if Puppet::Util.respond_to?(:absolute_path?)
      value = (Puppet::Util.absolute_path?(path, :posix) || Puppet::Util.absolute_path?(path, :windows))
    else
      # This code back-ported from 2.7.x's lib/puppet/util.rb Puppet::Util.absolute_path?
      # Determine in a platform-specific way whether a path is absolute. This
      # defaults to the local platform if none is specified.
      # Escape once for the string literal, and once for the regex.
      slash = '[\\\\/]'
      name = '[^\\\\/]+'
      regexes = {
        :windows => %r{^(([A-Z]:#{slash})|(#{slash}#{slash}#{name}#{slash}#{name})|(#{slash}#{slash}\?#{slash}#{name}))}i,
        :posix => %r{^/},
      }
      value = !!(path =~ regexes[:posix]) || !!(path =~ regexes[:windows]) # rubocop:disable Style/DoubleNegation : No alternative known
    end
    value
  end
end
