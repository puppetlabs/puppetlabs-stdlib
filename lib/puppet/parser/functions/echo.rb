Puppet::Parser::Functions::newfunction(:echo, :arity => -2, :doc => <<-EOS
This function output the variable content and its type to the
debug log. It's similiar to the "notice" function but provides
a better output format useful to trace variable types and values
in the manifests.

Example:
$v1 = 'test'
$v2 = ["1", "2", "3"]
$v3 = {"a"=>"1", "b"=>"2"}
$v4 = true
# $v5 is not defined
$v6 = { "b" => { "b" => [1,2,3], "c" => true, "d" => { 'x' => 'y' }}, 'x' => 'y', 'z' => [1,2,3,4,5,6]}
$v7 = 12345

echo($v1, 'My string')
echo($v2, 'My array')
echo($v3, 'My hash')
echo($v4, 'My boolean')
echo($v5, 'My undef')
echo($v6, 'My structure')
echo($v7) # no comment here

# debug log output
# My string (String) "test"
# My array (Array) ["1", "2", "3"]
# My hash (Hash) {"a"=>"1", "b"=>"2"}
# My boolean (TrueClass) true
# My undef (String) ""
# My structure (Hash) {"b"=>{"b"=>["1", "2", "3"], "c"=>true, "d"=>{"x"=>"y"}}, "x"=>"y", "z"=>["1", "2", "3", "4", "5", "6"]}
# (String) "12345"
EOS
) do |argv|
  value = argv[0]
  comment = argv[1]
  message = "(#{value.class}) #{value.inspect}"
  message = "#{comment} #{message}" if comment
  debug message
end
