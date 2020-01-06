# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# validate_email_address.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      Validate that all values passed are valid email addresses.
#      Fail compilation if any value fails this check.
#
#    @return
#      Fail compilation if any value fails this check.
#
#    @example **Usage**
#
#      The following values will pass:
#
#        $my_email = "waldo@gmail.com"
#        validate_email_address($my_email)
#        validate_email_address("bob@gmail.com", "alice@gmail.com", $my_email)
#
#      The following values will fail, causing compilation to abort:
#
#        $some_array = [ 'bad_email@/d/efdf.com' ]
#        validate_email_address($some_array)
#
#
Puppet::Functions.create_function(:'stdlib::validate_email_address') do
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
    
    rescuable_exceptions = [ArgumentError]

    if args.empty?
      raise Puppet::ParseError, "validate_email_address(): wrong number of arguments (#{args.length}; must be > 0)"
    end

    args.each do |arg|
      raise Puppet::ParseError, "#{arg.inspect} is not a string." unless arg.is_a?(String)

      begin
        raise Puppet::ParseError, "#{arg.inspect} is not a valid email address" unless function_is_email_address([arg])
      rescue *rescuable_exceptions
        raise Puppet::ParseError, "#{arg.inspect} is not a valid email address"
      end
    end
  
  end
end
