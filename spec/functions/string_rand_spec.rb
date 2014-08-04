#! /usr/bin/env ruby
require 'spec_helper'

describe "the string_rand function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("string_rand")).to eq("function_string_rand")
  end
  
  it "provides a random number strictly less than the given max" do
    scope.function_string_rand([3,'foo']).should satisfy {|n| n.to_i < 3 }
  end

  it "provides the same 'random' value on subsequent calls for the same string" do
    scope.function_string_rand([3,'foo']).should eql(scope.function_string_rand([3,'foo']))
  end

  it "should return different sequences of value for different string" do
    val1 = scope.function_string_rand([1000000000, 'this_foo'])
    val2 = scope.function_string_rand([1000000000, 'that_foo'])

    val1.should_not eql(val2)
  end

end
