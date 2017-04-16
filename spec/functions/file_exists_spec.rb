#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the file_exists function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  it "should exist" do
    Puppet::Parser::Functions.function("file_exists").should == "function_file_exists"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_file_exists([]) }.should( raise_error(Puppet::ParseError))
  end
end
