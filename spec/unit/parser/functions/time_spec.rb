#!/usr/bin/env rspec
require 'spec_helper'

describe "the time function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("time").should == "function_time"
  end

  it "should raise a ParseError if there is more than 2 arguments" do
    lambda { @scope.function_time(['','']) }.should( raise_error(Puppet::ParseError))
  end

end
