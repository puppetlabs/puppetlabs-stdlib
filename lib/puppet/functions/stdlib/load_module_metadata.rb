# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----
#
# load_module_metadata.rb
#
# ---- original file header ----
#
# @summary
#       @summary
#      This function loads the metadata of a given module.
#
#    @example Example USage:
#      $metadata = load_module_metadata('archive')
#      notify { $metadata['author']: }
#
#    @return
#      The modules metadata
#
#
Puppet::Functions.create_function(:'stdlib::load_module_metadata') do
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
    raise(Puppet::ParseError, 'load_module_metadata(): Wrong number of arguments, expects one or two') unless [1, 2].include?(args.size)
    mod = args[0]
    allow_empty_metadata = args[1]
    module_path = function_get_module_path([mod])
    metadata_json = File.join(module_path, 'metadata.json')

    metadata_exists = File.exists?(metadata_json) # rubocop:disable Lint/DeprecatedClassMethods : Changing to .exist? breaks the code
    if metadata_exists
      metadata = PSON.load(File.read(metadata_json))
    else
      metadata = {}
      raise(Puppet::ParseError, "load_module_metadata(): No metadata.json file for module #{mod}") unless allow_empty_metadata
    end

    metadata
  end
end
