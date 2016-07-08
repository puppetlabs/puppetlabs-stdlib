require 'spec_helper'

describe 'dig44' do
  it "should exist" do
    expect(Puppet::Parser::Functions.function("dig44")).to eq("function_dig44")
  end

  it "should raise a ParseError if there are less than 2 arguments" do
    expect { scope.function_dig44([]) }.to raise_error(Puppet::ParseError)
  end 

  it "should raise a ParseError if the first argument isn't a hash or array" do
    expect { scope.function_dig44(['bad', []]) }.to raise_error(Puppet::ParseError)
  end 

  it "should raise a ParseError if the second argument isn't an array" do
    expect { scope.function_dig44([{}, 'bad']) }.to raise_error(Puppet::ParseError)
  end

  it "should return an empty hash when given empty parameters" do
    result = scope.function_dig44([{}, []])
    expect(result).to(eq({}))
  end

  it "should return value when given simple hash" do
    result = scope.function_dig44([{"a" => "b"}, ["a"]])
    expect(result).to(eq("b"))
  end

  it "should find hash values two levels deep" do
    result = scope.function_dig44([{"a" => {"b" => "c"}}, ["a", "b"]])
    expect(result).to(eq("c"))
  end

  it "should return default value if nothing was found" do
    result = scope.function_dig44([{}, ["a", "b"], "d"])
    expect(result).to(eq("d"))
  end

  it "should work on booleans as well as strings" do
    result = scope.function_dig44([{"a" => false}, ["a"]])
    expect(result).to(eq(false))
  end
end
