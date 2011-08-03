#!/usr/bin/env rspec
require 'spec_helper'

describe "the load_yaml function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("load_yaml").should == "function_load_yaml"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_load_yaml([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should convert YAML to a data structure" do
    yaml = <<-EOS
- aaa
- bbb
- ccc
EOS
    result = @scope.function_load_yaml([yaml])
    result.should(eq(['aaa','bbb','ccc']))
  end

end
