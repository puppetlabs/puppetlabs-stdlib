#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dir exists function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("dir_exists")).to eq("function_dir_exists")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_dir_exists([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 arguments" do
    expect { scope.function_dir_exists([ 'a', 'b' ]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return true when is a directory" do
    result = scope.function_dir_exists(["/etc"])
    expect(result).to(eq(true))
  end

  it "should return false when is not a directory" do
    result = scope.function_dir_exists(["/etc/passwd"])
    expect(result).to(eq(false))
  end

  it "should return false when directory does not exist" do
    result = scope.function_dir_exists(["/no_dir"])
    expect(result).to(eq(false))
  end

end
