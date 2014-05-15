#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the bool2str function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("bool2str").should == "function_bool2str"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_bool2str([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should convert true to 'true'" do
    result = scope.function_bool2str([true])
    result.should(eq('true'))
  end

  it "should convert true to a string" do
    result = scope.function_bool2str([true])
    result.class.should(eq(String))
  end

  it "should convert false to 'false'" do
    result = scope.function_bool2str([false])
    result.should(eq('false'))
  end

  it "should convert false to a string" do
    result = scope.function_bool2str([false])
    result.class.should(eq(String))
  end

  it "should not accept a string" do
    lambda { scope.function_bool2str(["false"]) }.should( raise_error(Puppet::ParseError))
  end

  it "should not accept a nil value" do
    lambda { scope.function_bool2str([nil]) }.should( raise_error(Puppet::ParseError))
  end

  it "should not accept an undef" do
    lambda { scope.function_bool2str([:undef]) }.should( raise_error(Puppet::ParseError))
  end
end
