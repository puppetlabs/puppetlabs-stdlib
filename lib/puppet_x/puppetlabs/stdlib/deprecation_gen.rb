# Creates a Puppet 4 function for the corresponding puppet 3 validate function, who's name will be passed as an argument, alongside the type for deprecation output purposes.
module PuppetX
  module Puppetlabs
    module Stdlib
      def self.deprecation_gen(funct, type)
        Puppet::Functions.create_function(funct, Puppet::Functions::InternalFunction) do
          dispatch :deprecation_gen do
            scope_param
            optional_repeated_param 'Any', :args
          end
          define_method 'deprecation_gen' do |scope, *args|
            call_function('deprecation', 'puppet_3_type_check', "This method is deprecated, please use the stdlib validate_legacy function, with #{type}. There is further documentation for validate_legacy function in the README.")
            scope.send("function_#{funct}", args)
          end
        end
      end
    end
  end
end
