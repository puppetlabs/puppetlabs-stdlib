#!/usr/bin/env rspec
require 'spec_helper'

describe "the sort function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("sort").should == "function_sort"
  end

  it "should raise a ParseError if there is not 0 arguments" do
    lambda { @scope.function_sort(['']) }.should( raise_error(Puppet::ParseError))
  end

end
