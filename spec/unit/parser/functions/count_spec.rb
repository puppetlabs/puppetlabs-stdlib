#!/usr/bin/env rspec
require 'spec_helper'

describe "the count function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("count").should == "function_count"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_count([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return the size of an array" do
    result = @scope.function_count([['a','c','b']])
    result.should(eq(3))
  end

end
