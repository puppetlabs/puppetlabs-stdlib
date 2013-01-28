#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the ruby function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("ruby").should == "function_ruby"
  end

  it "should return the evaluated result" do
    result = scope.function_ruby(["1+3"])
    result.should(eq(4))
  end

  it "should have access to the scope variable" do
    result = scope.function_ruby(["scope.class"])
    result.should(eq("Puppet::Parser::Scope"))
  end
end
