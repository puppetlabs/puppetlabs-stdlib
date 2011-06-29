#!/usr/bin/env rspec
require 'spec_helper'

describe "the rand function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("rand").should == "function_rand"
  end

  it "should raise a ParseError if there is not 0 or 1 arguments" do
    lambda { @scope.function_rand(['a','b']) }.should( raise_error(Puppet::ParseError))
  end

end
