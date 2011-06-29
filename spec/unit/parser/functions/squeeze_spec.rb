#!/usr/bin/env rspec
require 'spec_helper'

describe "the squeeze function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("squeeze").should == "function_squeeze"
  end

  it "should raise a ParseError if there is less than 2 arguments" do
    lambda { @scope.function_squeeze([]) }.should( raise_error(Puppet::ParseError))
  end

end
