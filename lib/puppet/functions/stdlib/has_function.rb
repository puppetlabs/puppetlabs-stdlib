# frozen_string_literal: true

# @summary
#   Returns whether the Puppet runtime has access to a given function.
#
# @example Using stdlib::has_function()
#   stdlib::has_function('stdlib::has_function') # true
#   stdlib::has_function('not_a_function') # false
#
# Determines whether the Puppet runtime has access to a function by the
# name provided.
#
# @return
#   Returns true if the provided function name is available, false otherwise.
#
Puppet::Functions.create_function(:'stdlib::has_function', Puppet::Functions::InternalFunction) do
  dispatch :has_function do
    scope_param
    param 'String[1]', :function_name
    return_type 'Boolean'
  end

  def has_function(scope, function_name) # rubocop:disable Naming/PredicateName
    loaders = scope.compiler.loaders
    loader = loaders.private_environment_loader
    return true unless loader&.load(:function, function_name).nil?

    # If the loader cannot find the function it might be
    # a 3x-style function stubbed in on-the-fly for testing.
    func_3x = Puppet::Parser::Functions.function(function_name.to_sym)
    func_3x.is_a?(String) && !func_3x.empty?
  end
end
