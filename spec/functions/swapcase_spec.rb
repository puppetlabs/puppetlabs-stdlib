#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the swapcase function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("swapcase")).to eq("function_swapcase")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_swapcase([]) }.to( raise_error(ArgumentError))
  end

  it "should swapcase a string" do
    result = scope.function_swapcase(["aaBBccDD"])
    expect(result).to(eq('AAbbCCdd'))
  end
end
