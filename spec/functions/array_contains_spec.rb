require 'spec_helper'

describe "the array_contains function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("array_contains")).to eq("function_array_contains")
  end

  it "should raise a ParseError if a wrong number of arguments is provided" do
    expect { scope.function_array_contains([]) }.to( raise_error(Puppet::ParseError))
    expect { scope.function_array_contains(["a"]) }.to( raise_error(Puppet::ParseError))
    expect { scope.function_array_contains(["a", "b", ["c", "d"]]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return false if the second argument isn't an array" do
    expect { scope.function_array_contains(["a","b"]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return true if the element was found in the array" do
    expect(scope.function_array_contains(["a", ["a","b"]]) ).to eq(true)
  end

  it "should return false if the element was not found in the array" do
    expect(scope.function_array_contains(["x", ["a","b"]]) ).to eq(false)
  end
end
