#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the file_join function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("file_join").should == "function_file_join"
  end

  it "should join a list of strings into a path" do
    result = scope.function_file_join(["a","b","c"])
    result.should(eq("a/b/c"))
  end
  it "should join list of strings into a path without repeated /'s" do
    result = scope.function_file_join(["a/","/b/","/c"])
    result.should(eq("a/b/c"))
  end

  it "should join an array into a path" do
    result = scope.function_file_join([["a","b","c"]])
    result.should(eq("a/b/c"))
  end

  it "should join a mixed set of arrays and strings into a path" do
    result = scope.function_file_join([["a/","/b/","/c"],"d.conf"])
    result.should(eq("a/b/c/d.conf"))
  end

  it "should raise a ParseError if passed a hash" do
    lambda { scope.function_file_join([{"one"=>"two"}]) }.should( raise_error(Puppet::ParseError))
    lambda { scope.function_file_join([[{"one"=>"two"},"three","four"],"five"]) }.should( raise_error(Puppet::ParseError))
  end
end
