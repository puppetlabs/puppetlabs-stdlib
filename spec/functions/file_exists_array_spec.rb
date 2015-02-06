#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the file exists array function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("file_exists_array")).to eq("function_file_exists_array")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_file_exists_array([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 arguments" do
    expect { scope.function_file_exists_array([ ['a'], ['b'] ]) }.to( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the argument is not an Array" do
    expect { scope.function_file_exists_array([ 'a' ]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return an array of existing files" do
    result = scope.function_file_exists_array([ ["/etc/passwd", "/no_file" ] ])
    expect(result).to(eq(["/etc/passwd"]))
  end

  it "should return an empty array if no files found" do
    result = scope.function_file_exists_array([ [ "/no_file", "/another_no_file" ]])
    expect(result).to(eq([]))
  end

  it "should return an array only with existing files (no directories)" do
    result = scope.function_file_exists_array([ [ "/etc/passwd", "/etc" ]])
    expect(result).to(eq(["/etc/passwd"]))
  end

end
