#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'echo function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  values = [
      [ "'test'", 'My string', %q|My string (String) "test"| ],
      [ '["1", "2", "3"]', 'My array', %q|My array (Array) ["1", "2", "3"]| ],
      [ '{"a" => "1", "b" => "2"}', 'My hash', %q|My hash (Hash) {"a"=>"1", "b"=>"2"}| ],
      [ 'true', 'My boolean', %q|My boolean (TrueClass) true|,  ],
      [ 'nil', 'My undef', %q|My undef (String) ""| ],
      [ '{"a" => ["1", "2", "3"]}', 'My structure', %q|My structure (Hash) {"a"=>["1", "2", "3"]}| ],
      [ '12345', nil, %q|(String) "12345"| ]
  ]

  values.each do |value, comment, regexp|
    it "output for: #{value}" do
      if comment
        pp = "echo(#{value}, '#{comment}')"
      else
        pp = "echo(#{value})"
      end

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to include(regexp)
      end
    end
  end

end
