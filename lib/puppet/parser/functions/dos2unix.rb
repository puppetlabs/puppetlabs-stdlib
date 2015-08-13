# Custom Puppet function to convert dos to unix format
module Puppet::Parser::Functions
  newfunction(:dos2unix, :type => :rvalue) do |args|
    args[0].gsub(/\r\n/, "\n")
  end
end
