# file_exists.rb
# Simple function that check if a file exist or not
#
# Created by Jerome RIVIERE (www.jerome-riviere.re) (https://github.com/ninja-2)

module Puppet::Parser::Functions
  newfunction(:file_exists, :type => :rvalue) do |args|
    if File.exists?(args[0])
      return true
    else
     return false
    end
  end
end