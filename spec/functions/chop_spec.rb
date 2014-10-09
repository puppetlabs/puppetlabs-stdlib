#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the chop function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("chop")).to eq("function_chop")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_chop([]) }.to( raise_error(ArgumentError))
  end

  it "should chop the end of a string" do
    result = scope.function_chop(["asdf\n"])
    expect(result).to(eq("asdf"))
  end
end
