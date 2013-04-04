#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe "the sha1_passwd function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("sha1_passwd").should == "function_sha1_passwd"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_sha1_passwd([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 argument" do
    lambda { scope.function_sha1_passwd(['foo', 'bar']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if passed a number" do
    lambda { scope.function_sha1_passwd([42]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if passed a hash" do
    lambda { scope.function_sha1_passwd([{:a => '42', }]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return a SHA1 password" do
    result = scope.function_sha1_passwd(['testpassword'])
    result.should(eq('{SHA}i7YRj4/Wk1rQh2o740pxfTJwj/0='))
  end
end
