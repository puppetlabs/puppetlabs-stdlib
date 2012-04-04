#!/usr/bin/env rspec
require 'spec_helper'

describe "the function_available function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("function_available").should == "function_function_available"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_function_available([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return false if a nonexistent function is passed" do
    result = @scope.function_function_available(['hooba_porkrind'])
    result.should(eq(false))
  end

  it "should return generated function name for an available function" do
    result = @scope.function_function_available(['require'])
    result.should(eq('function_require'))
  end

end
