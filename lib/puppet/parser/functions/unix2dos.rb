# Custom Puppet function to convert unix to dos format
module Puppet::Parser::Functions
  newfunction(:unix2dos, :type => :rvalue) do |args|
    args[0].gsub(/\r*\n/, "\r\n")
  end
end
