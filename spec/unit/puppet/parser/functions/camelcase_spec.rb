#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the camelcase function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("camelcase").should == "function_camelcase"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_camelcase([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should capitalize the beginning of a normal string" do
    result = scope.function_camelcase(["abc"])
    result.should(eq("Abc"))
  end

  it "should camelcase an underscore-delimited string" do
    result = scope.function_camelcase(["aa_bb_cc"])
    result.should(eq("AaBbCc"))
  end
end
