# Function to load a class if the class is available
module Puppet::Parser::Functions
  newfunction(:loadclass_ifexists) do |args|
    Puppet::Parser::Functions.function('ensure_resource')
      
    begin
      function_ensure_resource(['class',args[0]])
    rescue ArgumentError
    end  
    
  end 
end