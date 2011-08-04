#!/usr/bin/env rspec
require 'spec_helper'

describe "the join function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("join").should == "function_join"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_join([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if a single string is given" do
    lambda { @scope.function_join(["a"]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if argc > 3 and non-strings are given" do
    lambda { @scope.function_join(["a",["b"],false]) }.should( raise_error(Puppet::ParseError))
  end

  it "should join an array into a string" do
    result = @scope.function_join([["a","b","c"], ":"])
    result.should(eq("a:b:c"))
  end

  it "should join an array into a string without separator" do
    result = @scope.function_join([["a","b","c"]])
    result.should(eq("abc"))
  end

  it "should join an array into a string even if it has 1 element" do
    result = @scope.function_join([["a"]])
    result.should(eq("a"))
  end

  it "should join 1-element array into a string consistently with Ruby" do
    result = @scope.function_join([["a"],":"])
    result.should(eq("a"))
  end

  it "should join two strings in one" do
    result = @scope.function_join(["a","b"])
    result.should(eq("ab"))
  end

  it "should join two strings with a separator" do
    result = @scope.function_join(["a","b",":"])
    result.should(eq("a:b"))
  end

  it "should join three strings with a separator" do
    result = @scope.function_join(["a","b","c",":"])
    result.should(eq("a:b:c"))
  end

end
