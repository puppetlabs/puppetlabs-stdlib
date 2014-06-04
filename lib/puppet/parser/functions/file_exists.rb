# file_exists.rb
# Simple function that check if a file exist or not
#
# Created by Jerome RIVIERE (www.jerome-riviere.re) (https://github.com/ninja-2)
require "puppet"

module Puppet::Parser::Functions
  newfunction(:file_exists, :type => :rvalue, :doc => <<-EOS
Returns true if the file exists.
    EOS
  ) do |args|
    if File.exists?(args[0])
      return true
    else
     return false
    end
  end
end