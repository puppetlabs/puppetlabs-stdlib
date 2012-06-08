#!/usr/bin/env rspec
require 'spec_helper'

describe "the str2bool function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("str2bool").should == "function_str2bool"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_str2bool([]) }.should( raise_error(Puppet::ParseError))
  end

  true_values = [ 'true', 't', 'yes', 'y', '1' ]

  true_values.each do |v|
    it "should convert string '#{v}' to true" do
      result = @scope.function_str2bool([v])
      result.should(eq(true))
    end
  end

  false_values = [ 'false', 'f', 'no', 'n', '0', 'undef', '' ]

  false_values.each do |v|
    it "should convert string '#{v}' to false" do
      result = @scope.function_str2bool([v])
      result.should(eq(false))
    end
  end

end
