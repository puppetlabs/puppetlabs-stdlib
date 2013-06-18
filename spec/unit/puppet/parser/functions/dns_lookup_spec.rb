#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dns_lookup function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  it "should exist" do
    Puppet::Parser::Functions.function("dns_lookup").should == "function_dns_lookup"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_dns_lookup([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should lookup a mix of ip's and hostnames" do
    result = scope.function_dns_lookup(['1.2.3.4','example.com','4.3.2.1'])
    result.should(eq(['1.2.3.4','192.0.43.10','4.3.2.1']))
  end

  it "should ignore CIDR notation" do
    result = scope.function_dns_lookup(['1.2.3.4/32'])
    result.should(eq(['1.2.3.4/32']))
  end

  it "should ignore and return unresolvable hostnames" do
    result = scope.function_dns_lookup(['1.2.3.4','ireallydonotexistever.net','4.3.2.1','exist'])
    result.should(eq(['1.2.3.4','ireallydonotexistever.net','4.3.2.1','exist']))
  end

end
