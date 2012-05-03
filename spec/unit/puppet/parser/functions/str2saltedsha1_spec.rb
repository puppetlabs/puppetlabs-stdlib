#!/usr/bin/env rspec
require 'spec_helper'

describe "the str2saltedsha1 function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("str2saltedsha1").should == "function_str2saltedsha1"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    expect { @scope.function_str2saltedsha1([]) }.should( raise_error(Puppet::ParseError) )
  end

  it "should raise a ParseError if there is more than 1 argument" do
    expect { @scope.function_str2saltedsha1(['foo', 'bar', 'baz']) }.should( raise_error(Puppet::ParseError) )
  end

  it "should return a salted-sha512 password hash 1240 characters in length" do
    result = @scope.function_str2saltedsha1(["password"])
    result.length.should(eq(1240))
  end

  it "should raise an error if you pass a non-string password" do
    expect { @scope.function_str2saltedsha1([1234]) }.should( raise_error(Puppet::ParseError) )
  end
end
