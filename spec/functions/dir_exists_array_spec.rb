#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dir exists array function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("dir_exists_array")).to eq("function_dir_exists_array")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_dir_exists_array([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 arguments" do
    expect { scope.function_dir_exists_array([ ['a'], ['b'] ]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the argument is not an Array" do
    expect { scope.function_dir_exists_array([ 'a' ]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return an array of existing directories" do
    result = scope.function_dir_exists_array([ ["/etc", "/no_dir" ] ])
    expect(result).to(eq(["/etc"]))
  end

  it "should return an empty array if no directories found" do
    result = scope.function_dir_exists_array([ [ "/no_dir", "/another_no_dir" ]])
    expect(result).to(eq([]))
  end

  it "should return an array only with existing directories (no files)" do
    result = scope.function_dir_exists_array([ [ "/etc", "/etc/passwd" ]])
    expect(result).to(eq(["/etc"]))
  end

end
