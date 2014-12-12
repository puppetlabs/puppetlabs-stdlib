#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the basename function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("basename")).to eq("function_basename")
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    expect { scope.function_basename([]) }.to( raise_error(Puppet::ParseError))
  end

  it "should return basename for an absolute path" do
    result = scope.function_basename(['/path/to/a/file.ext'])
    expect(result).to(eq('file.ext'))
  end

  it "should return basename for a relative path" do
    result = scope.function_basename(['path/to/a/file.ext'])
    expect(result).to(eq('file.ext'))
  end
end
