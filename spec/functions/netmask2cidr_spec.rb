#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the netmask2cidr function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("netmask2cidr")).to eq("function_netmask2cidr")
  end

  it "should only accept one argument" do
    expect do
      should run.with_params('FOO','bar').and_return('bar')
    end.to raise_error(ArgumentError, /wrong number of arguments/)
  end

  it "should convert  netmask to cidr" do
    result = scope.function_netmask2cidr(['255.255.255.0'])
    expect(result).to(eq(24))
  end
end
