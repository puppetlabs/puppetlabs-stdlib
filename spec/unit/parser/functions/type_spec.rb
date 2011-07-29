#!/usr/bin/env rspec
require 'spec_helper'

describe "the type function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("type").should == "function_type"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_type([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return String when given a string" do
    result = @scope.function_type(["aaabbbbcccc"])
    result.should(eq('String'))
  end

  it "should return Array when given an array" do
    result = @scope.function_type([["aaabbbbcccc","asdf"]])
    result.should(eq('Array'))
  end

  it "should return Hash when given a hash" do
    result = @scope.function_type([{"a"=>1,"b"=>2}])
    result.should(eq('Hash'))
  end

end
