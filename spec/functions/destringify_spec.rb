require 'spec_helper'

describe "the destringify function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("destringify")).to eq("function_destringify")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_destringify([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 arguments" do
    expect { scope.function_destringify(['a','b']) }.to( raise_error(Puppet::ParseError))
  end

  it "should destringify a stringified hash" do
    result = scope.function_destringify(["{\"key1\"=>{\"key11\"=>11, \"key12\"=>12}}"])
    expect(result).to(eq({'key1' => { 'key11' => 11 ,'key12' => 12}}))
  end

  it "should destringify a stringified array" do
    result = scope.function_destringify(["[\"one\", true, 100]"])
    expect(result).to(eq(['one', true, 100]))
  end

  it "should destringify a stringified boolean" do
    result = scope.function_destringify(["true"])
    expect(result).to(eq(true))
  end

  it "should destringify a stringified integer" do
    result = scope.function_destringify(["1000"])
    expect(result).to(eq(1000))
  end

  it "should passthrough a hash" do
    result = scope.function_destringify([{'key1' => { 'key11' => 11 ,'key12' => 12}}])
    expect(result).to(eq({'key1' => { 'key11' => 11 ,'key12' => 12}}))
  end

  it "should passthrough an array" do
    result = scope.function_destringify([['one', true, 100]])
    expect(result).to(eq(['one', true, 100]))
  end

  it "should passthrough an integer" do
    result = scope.function_destringify([1000])
    expect(result).to(eq(1000))
  end

  it "should passthrough a boolean" do
    result = scope.function_destringify([true])
    expect(result).to(eq(true))
  end

  it "should passthrough a standard string" do
    result = scope.function_destringify(["hello there, i'm a standard string"])
    expect(result).to(eq("hello there, i'm a standard string"))
  end

end
