#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the file exists function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("file_exists")).to eq("function_file_exists")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_file_exists([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 arguments" do
    expect { scope.function_file_exists([ 'a', 'b' ]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return true when is a file" do
    result = scope.function_file_exists(["/etc/passwd"])
    expect(result).to(eq(true))
  end

  it "should return false when is not a file" do
    result = scope.function_file_exists(["/etc"])
    expect(result).to(eq(false))
  end

  it "should return false when file does not exist" do
    result = scope.function_file_exists(["/no_file"])
    expect(result).to(eq(false))
  end
end
