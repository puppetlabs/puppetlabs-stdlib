#!/usr/bin/env rspec
require 'spec_helper'

describe "the values function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("values").should == "function_values"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_values([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return values from a hash" do
    result = @scope.function_values([{'a'=>'1','b'=>'2','c'=>'3'}])
    result.should(eq(['1','2','3']))
  end

  it "should return values from a hash" do
    lambda { @scope.function_values([['a','b','c']]) }.should( raise_error(Puppet::ParseError))
  end

end
