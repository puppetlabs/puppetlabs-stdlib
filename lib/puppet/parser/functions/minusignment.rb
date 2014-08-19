# Test whether a given class or definition is defined
require 'puppet/parser/functions'

Puppet::Parser::Functions.newfunction(:minusignment,
                                      #:type => :rvalue,
                                      :doc => <<-'ENDOFDOC'
Takes a resource reference, the name of the parameter,
and a value, removing the value from resource's parameter.

*Examples:*

    example_resource { 'example_resource_instance':
        param => [ 'param_value1', 'param_value2' ],
    }

    minusignment(Example_resource['example_resource_instance'], 'param', 'param_value2')

Would return:
    Example_resource { 'example_resource_instance':
        param => [ 'param_value1' ],
    }
ENDOFDOC
) do |vals|
  reference, param, value = vals
  raise(ArgumentError, 'Must specify a reference') unless reference
  raise(ArgumentError, 'Must specify name of a parameter') unless param and param.instance_of? String
  raise(ArgumentError, 'Must specify name of a value') unless value

  if resource = findresource(reference.to_s)
    new = function_delete(resource[param], value)
    resource.set_parameter(param, new) unless param == new
  end

end
