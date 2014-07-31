#!/usr/bin/env ruby -S rspec

require 'spec_helper'
describe "the create_password function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("create_password")).to eq("function_create_password")
  end
  
  it "should fail: no salt provided" do
    expect {
      scope.function_create_password([])
    }.to raise_error(Puppet::ParseError, "create_password(): Expects at least 1 argument, 3 at most, not 0")
  end
  
  it "should fail: 4 arguments when expecting 3 at most" do
    expect {
      scope.function_create_password(['foo', 1000, 200, 'bar'])
    }.to raise_error(Puppet::ParseError, "create_password(): Expects at least 1 argument, 3 at most, not 4")
  end
  
  it "should fail: salt not a String" do
    expect {
      scope.function_create_password([1000])
    }.to raise_error(Puppet::ParseError, "create_password(): Expects argument 1 (salt) to be a String")
  end
  
  it "should fail: iteration not an Integer" do
    expect {
      scope.function_create_password(['mysalt','bar'])
    }.to raise_error(Puppet::ParseError, "create_password(): Expects argument 2 (iteration) to be an Integer")
  end
  
  it "should fail: salt not a string" do
    expect {
      scope.function_create_password(['mysalt', 1000, 'foo'])
    }.to raise_error(Puppet::ParseError, "create_password(): Expects argument 3 (password size) to be an Integer")
  end
  
  it "should return a hash begining with $6$" do
    scope.expects(:lookupvar).with('fqdn').returns('foo.example.com')
    expect(scope.function_create_password(['abcdefg128'])).to match(/\$6\$\+ytEV6jcTux\$/)
  end

end
