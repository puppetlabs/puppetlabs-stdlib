#!/usr/bin/env rspec
require 'spec_helper'

describe "the member function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("member").should == "function_member"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_member([]) }.should( raise_error(Puppet::ParseError))
  end

end
