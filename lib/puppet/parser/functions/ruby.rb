Puppet::Parser::Functions::newfunction(:ruby, :type => :rvalue, :arity => 1, :doc =>
  "Evaluate a Ruby string and return its value.") do |args|

  # Make sure we can access the scope through the variable scope
  scope = self

  eval(args[0])
end
