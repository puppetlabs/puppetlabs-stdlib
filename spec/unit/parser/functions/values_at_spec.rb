#!/usr/bin/env rspec
require 'spec_helper'

describe "the values_at function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("values_at").should == "function_values_at"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_values_at([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return a value at from an array" do
    result = @scope.function_values_at([['a','b','c'],"1"])
    result.should(eq(['b']))
  end

end
