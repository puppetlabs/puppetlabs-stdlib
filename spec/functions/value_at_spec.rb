#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the value_at function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("value_at")).to eq("function_value_at")
  end

  it "should raise a ParseError if there is less than 2 arguments" do
    expect { scope.function_value_at([{'a'=>'1'}]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError unless a Hash is provided" do
    expect { scope.function_value_at([['a','b','c'], 'a']) }.to( raise_error(Puppet::ParseError))
  end

  it "should return value for given key from a hash" do
    result = scope.function_value_at([{'a'=>'1','b'=>'2','c'=>'3'}, 'c'])
    expect(result).to eq('3')
  end

  it "should return given default value if key not found in a hash" do
    result = scope.function_value_at([{'a'=>'1','b'=>'2','c'=>'3'}, 'z', '26'])
    expect(result).to eq('26')
  end
end
