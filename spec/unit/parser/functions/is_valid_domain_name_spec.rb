#!/usr/bin/env rspec
require 'spec_helper'

describe "the is_valid_domain_name function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("is_valid_domain_name").should == "function_is_valid_domain_name"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { @scope.function_is_valid_domain_name([]) }.should( raise_error(Puppet::ParseError))
  end

end
