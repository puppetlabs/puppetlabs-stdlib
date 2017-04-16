#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the truncate function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("truncate").should == "function_truncate"
  end

  it "should raise a ParseError if there is less than 2 arguments" do
    lambda { scope.function_truncate(['foo']) }.should( raise_error(Puppet::ParseError))
  end

  it "should truncate given strings" do
    expected = 'foo'

    result = scope.function_truncate(['foobar', 2])
    result.should(eq(expected))
  end
end
