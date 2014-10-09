#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the bool2num function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("bool2num")).to eq("function_bool2num")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_bool2num([]) }.to( raise_error(ArgumentError))
  end

  it "should convert true to 1" do
    result = scope.function_bool2num([true])
    expect(result).to(eq(1))
  end

  it "should convert false to 0" do
    result = scope.function_bool2num([false])
    expect(result).to(eq(0))
  end
end
