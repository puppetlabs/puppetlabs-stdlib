#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the upcase function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("upcase")).to eq("function_upcase")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_upcase([]) }.to( raise_error(ArgumentError))
  end

  it "should upcase a string" do
    result = scope.function_upcase(["abc"])
    expect(result).to(eq('ABC'))
  end

  it "should do nothing if a string is already upcase" do
    result = scope.function_upcase(["ABC"])
    expect(result).to(eq('ABC'))
  end
end
