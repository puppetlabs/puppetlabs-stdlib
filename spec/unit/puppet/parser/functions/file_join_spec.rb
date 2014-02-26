#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the file_join function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("file_join").should == "function_file_join"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_file_join([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should join an array into a path" do
    result = scope.function_file_join([["a","b","c"]])
    result.should(eq("a/b/c"))
  end
  it "should join an array into a path without repeated /'s" do
    result = scope.function_file_join([["a/","/b/","/c"]])
    result.should(eq("a/b/c"))
  end
end
