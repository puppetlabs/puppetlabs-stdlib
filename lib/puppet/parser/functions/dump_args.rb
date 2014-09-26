require 'json'
require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:dump_args, :type => :statement,:doc => <<-EOS
     dump_args - prints the args to STDOUT in Pretty JSON format.

     Useful for debugging purposes only. Ideally you would use this in
     conjunction with a rspec-puppet unit test.  Otherwise the output will
     be shown during a puppet run when verbose/debug options are enabled.

  EOS
  )  do |args|
    puts JSON.pretty_generate(args)
  end

end
