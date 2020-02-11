#
#    @summary
#      This function loads the metadata of a given module.
#
#    @example Example Usage:
#      $metadata = load_module_metadata('archive')
#      notify { $metadata['author']: }
#
#    @return
#      The modules metadata
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
    param 'String', :module_name
    optional_param 'Bool', :allow_empty_metadata
  end

  def default_impl(module_name, allow_empty_metadata)
    module_path = function_get_module_path([module_name])
    metadata_json = File.join(module_path, 'metadata.json')

    if File.exists?(metadata_json)
      return Puppet::Util::Json.load(File.read(metadata_json))

    else
      if !allow_empty_metadata
        raise(Puppet::ParseError,
              "load_module_metadata(): No metadata.json file for module #{module_name}")
      end

      return Hash.new
    end
  end
end
