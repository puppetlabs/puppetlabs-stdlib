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

end
