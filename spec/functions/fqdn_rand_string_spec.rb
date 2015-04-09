#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the fqdn_rand_string function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("fqdn_rand_string")).to eq("function_fqdn_rand_string")
  end

  it "should raise an ArgumentError if there is less than 1 argument" do
    expect { fqdn_rand_string() }.to( raise_error(ArgumentError, /wrong number of arguments/))
  end

  it "should raise an ArgumentError if argument 1 isn't a positive integer" do
    expect { fqdn_rand_string(0) }.to( raise_error(ArgumentError, /first argument must be a positive integer/))
    expect { fqdn_rand_string(-1) }.to( raise_error(ArgumentError, /first argument must be a positive integer/))
    expect { fqdn_rand_string(0.5) }.to( raise_error(ArgumentError, /first argument must be a positive integer/))
  end

  it "provides a valid alphanumeric string when no character set is provided" do
    length = 100
    string = %r{\A[a-zA-Z0-9]{#{length}}\z}
    expect(fqdn_rand_string(length).match(string)).not_to eq(nil)
  end

  it "provides a valid alphanumeric string when an undef character set is provided" do
    length = 100
    string = %r{\A[a-zA-Z0-9]{#{length}}\z}
    expect(fqdn_rand_string(length, :charset => nil).match(string)).not_to eq(nil)
  end

  it "provides a valid alphanumeric string when an empty character set is provided" do
    length = 100
    string = %r{\A[a-zA-Z0-9]{#{length}}\z}
    expect(fqdn_rand_string(length, :charset => '').match(string)).not_to eq(nil)
  end

  it "uses a provided character set" do
    length = 100
    charset = '!@#$%^&*()-_=+'
    string = %r{\A[#{charset}]{#{length}}\z}
    expect(fqdn_rand_string(length, :charset => charset).match(string)).not_to eq(nil)
  end

  it "provides a random string exactly as long as the given length" do
    expect(fqdn_rand_string(10).size).to eql(10)
  end

  it "provides the same 'random' value on subsequent calls for the same host" do
    expect(fqdn_rand_string(10)).to eql(fqdn_rand_string(10))
  end

  it "considers the same host and same extra arguments to have the same random sequence" do
    first_random = fqdn_rand_string(10, :extra_identifier => [1, "same", "host"])
    second_random = fqdn_rand_string(10, :extra_identifier => [1, "same", "host"])

    expect(first_random).to eql(second_random)
  end

  it "allows extra arguments to control the random value on a single host" do
    first_random = fqdn_rand_string(10, :extra_identifier => [1, "different", "host"])
    second_different_random = fqdn_rand_string(10, :extra_identifier => [2, "different", "host"])

    expect(first_random).not_to eql(second_different_random)
  end

  it "should return different strings for different hosts" do
    val1 = fqdn_rand_string(10, :host => "first.host.com")
    val2 = fqdn_rand_string(10, :host => "second.host.com")

    expect(val1).not_to eql(val2)
  end

  def fqdn_rand_string(max, args = {})
    host = args[:host] || '127.0.0.1'
    charset = args[:charset]
    extra = args[:extra_identifier] || []

    scope = PuppetlabsSpec::PuppetInternals.scope
    scope.stubs(:[]).with("::fqdn").returns(host)
    scope.stubs(:lookupvar).with("::fqdn").returns(host)

    function_args = [max]
    if args.has_key?(:charset) or !extra.empty?
      function_args << charset
    end
    function_args += extra
    scope.function_fqdn_rand_string(function_args)
  end
end
