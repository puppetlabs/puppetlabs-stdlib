#!/usr/bin/env rspec
require 'spec_helper'

describe "the dashboard_json function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("dashboard_json").should == "function_dashboard_json"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_dashboard_json([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should convert JSON to a data structure" do
    json = <<-EOS
[\\\"aaa\\\",\\\"bbb\\\",\\\"ccc\\\"]
EOS
    result = @scope.function_dashboard_json([json])
    result.should(eq(["aaa","bbb","ccc"]))
  end

end
