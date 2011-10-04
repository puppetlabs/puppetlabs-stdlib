#!/usr/bin/env rspec

require 'spec_helper'
require 'net/http'
require 'thread'
require 'fileutils'

describe "the get_pubkey function" do
  include PuppetSpec::Files

  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("get_pubkey").should == "function_get_pubkey"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { @scope.function_get_pubkey([]) }.should(raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the argument is empty" do
    lambda { @scope.function_get_pubkey([""]) }.should(raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the argument contains strange characters" do
    lambda { @scope.function_get_pubkey(["%^&"]) }.should(raise_error(Puppet::ParseError))
  end

  it "should return a valid certificate if CA is local" do
    Puppet[:ca] = true
    Puppet[:signeddir] = "spec/master_config/ssl/ca/signed/"
    result = @scope.function_get_pubkey(["bob@mydomain.com"])
    result.should(eq(<<-EOS))
-----BEGIN RSA PUBLIC KEY-----
MIGJAoGBAL7+Idbd+eohxCXVXcICvo1IaqAzyjezWxfxMxoBF4mjdvwY9RalRM5j
Itm9ThVwLMezcISYSNPI42Y70+9XIK/3f6OxnSMoB7kDKX9MvcbZkRAtOfxDeWmA
un+PXuH87VN1r7sViRSSB2dIxB3qjF1HNhAm0ocmSW+sZ3eul2lpAgMBAAE=
-----END RSA PUBLIC KEY-----
EOS
  end

  it "should throw an error if CN is missing and CA is local" do
    Puppet[:ca] = true
    Puppet[:signeddir] = "spec/master_config/ssl/ca/signed/"
    result = @scope.function_get_pubkey(["missing@mydomain.com"])
    result.should(eq(:undef))
  end
end
