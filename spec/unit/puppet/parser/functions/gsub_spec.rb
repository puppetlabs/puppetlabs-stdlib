#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the gsub function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("gsub").should == "function_gsub"
  end

  it "should raise a ParseError if there less than 3 arguments" do
    lambda { scope.function_gsub([]) }.should( raise_error(Puppet::ParseError))
    lambda { scope.function_gsub(['1','[0-9]+']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there less than 3 arguments" do
    lambda { scope.function_gsub([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there less than 3 arguments" do
    lambda { scope.function_gsub(['1','[0-9]+', true]) }.should( raise_error(Puppet::ParseError, /Requires a string for the last argument/))
  end

  it "should raise a ParseError if there less than 3 arguments" do
    lambda { scope.function_gsub([[],'[0-9]+', 'foo']) }.should( raise_error(Puppet::ParseError, /Requires a string for the first argument/))
  end

  it "should raise a ParseError if the regex is incorrect" do
    lambda { scope.function_gsub(["AbC",'*',"foo"]) }.should( raise_error(Puppet::ParseError, /Regex given was incorrect/))
  end

  it "should correctly gsub a string" do
    result_1 = scope.function_gsub(["Foo123",'[0-9]+',"ZZZ"])
    result_1.should(eq('FooZZZ'))
  end
end
