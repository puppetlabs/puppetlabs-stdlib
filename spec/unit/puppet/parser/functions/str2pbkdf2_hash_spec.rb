#!/usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the str2pbkdf2_hash function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("str2pbkdf2_hash").should == "function_str2pbkdf2_hash"
  end

  it "should raise a ParseError if there is less than 3 arguments" do
    expect { scope.function_str2pbkdf2_hash([]) }.
     to raise_error Puppet::ParseError, /Wrong number of arguments/
  end

  it "should raise a ParseError if there is more than 3 arguments" do
    expect { scope.function_str2pbkdf2_hash(['foo', 'bar', 'baz', 'buz']) }.
      to raise_error Puppet::ParseError, /Wrong number of arguments/
  end

  it "should return a salted-sha512-pbkdf2 password hash 256 characters in length" do
    result = scope.function_str2pbkdf2_hash(["password", 'salt', 10000])
    result.length.should(eq(256))
  end

  it "should raise an error if you pass a non-string password" do
    expect { scope.function_str2pbkdf2_hash([1234,'salt', 10000]) }.
      to raise_error Puppet::ParseError, /The first argument.+must be a String/
  end

  it "should raise an error if you pass a non-string salt" do
    expect { scope.function_str2pbkdf2_hash(['password', 1234, 10000]) }.
      to raise_error Puppet::ParseError, /The second argument.+must be a String/
  end

  it "should raise an error if you pass a non-integer iterations value" do
    expect { scope.function_str2pbkdf2_hash(['password', 'salt', 'buckeyebill']) }.
      to raise_error Puppet::ParseError, /The third argument, the iterations value, could not be cast to an Integer/
  end

  it "should generate a valid password" do
    pw_hash = '72629a41b076e588fba8c71ca37fadc9acdc8e7321b9cb4ea55fd0bf9fe8ed72def92b4c7dff5242a0254945b945394ce4d6008e947bdc7593085cd1e2f6a375e3efe32510e0f982abcc57991cb705243a3a42086e6a9e56c7b063c72636793b7622587882a872b19bb15e8fc8a865a8e83264bf802d0e52f825f18cc46a2147'

    scope.function_str2pbkdf2_hash(["password", 'salt', 10000] \
                                    ).should(eq(pw_hash))
  end
end
