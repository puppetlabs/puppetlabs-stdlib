#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the str2bool function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("str2bool").should == "function_str2bool"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_str2bool([]) }.should( raise_error(Puppet::ParseError))
  end

  true_values = [ 'true', 't', 'yes', 'y', '1', 'anything' ]

  true_values.each do |v|
    it "should convert string '#{v}' to true" do
      result = scope.function_str2bool([v])
      result.should(eq(true))
    end
  end

  false_values = [ 'false', 'f', 'no', 'n', '0', 'undef', '' ]

  false_values.each do |v|
    it "should convert string '#{v}' to false" do
      result = scope.function_str2bool([v])
      result.should(eq(false))
    end
  end
end
