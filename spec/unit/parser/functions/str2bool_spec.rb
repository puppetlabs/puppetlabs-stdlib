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

end
