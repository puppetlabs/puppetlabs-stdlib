#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the swapcase function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("swapcase").should == "function_swapcase"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_swapcase([]) }.should( raise_error(ArgumentError))
  end

  it "should swapcase a string" do
    result = scope.function_swapcase(["aaBBccDD"])
    result.should(eq('AAbbCCdd'))
  end
end
