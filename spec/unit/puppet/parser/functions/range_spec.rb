#!/usr/bin/env rspec
require 'spec_helper'

describe "the range function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("range").should == "function_range"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_range([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return a letter range" do
    result = @scope.function_range(["a","d"])
    result.should(eq(['a','b','c','d']))
  end

  it "should return a letter range given a step of 1" do
    result = @scope.function_range(["a","d","1"])
    result.should(eq(['a','b','c','d']))
  end

  it "should return a stepped letter range" do
    result = @scope.function_range(["a","d","2"])
    result.should(eq(['a','c']))
  end

  it "should return a stepped letter range given a negative step" do
    result = @scope.function_range(["1","4","-2"])
    result.should(eq(['a','c']))
  end

  it "should return a number range" do
    result = @scope.function_range(["1","4"])
    result.should(eq([1,2,3,4]))
  end

  it "should return a number range given a step of 1" do
    result = @scope.function_range(["1","4","1"])
    result.should(eq([1,2,3,4]))
  end

  it "should return a stepped number range" do
    result = @scope.function_range(["1","4","2"])
    result.should(eq([1,3]))
  end

  it "should return a stepped number range given a negative step" do
    result = @scope.function_range(["1","4","-2"])
    result.should(eq([1,3]))
  end

end
