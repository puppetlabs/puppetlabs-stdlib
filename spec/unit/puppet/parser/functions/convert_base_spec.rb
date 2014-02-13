#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe "the convert_base function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("convert_base").should == "function_convert_base"
  end

  it "should raise a ParseError if there are other than 2 arguments" do
    expect { scope.function_convert_base([]) }.to(raise_error(Puppet::ParseError))
    expect { scope.function_convert_base(["asdf"]) }.to(raise_error(Puppet::ParseError))
    expect { scope.function_convert_base(["asdf","moo","cow"]) }.to(raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if argument 1 isn't a string or a number" do
    expect { scope.function_convert_base([["2"],"1"]) }.to(raise_error(Puppet::ParseError, /argument must be either a string or an integer/))
  end

  it "should raise a ParseError if argument 2 isn't a string or a number" do
    expect { scope.function_convert_base(["encode",["2"]]) }.to(raise_error(Puppet::ParseError, /argument must be either a string or an integer/))
  end

  it "should raise a ParseError if argument 1 is a string that does not correspond to an integer in base 10" do
    expect { scope.function_convert_base(["ten",6]) }.to(raise_error(Puppet::ParseError, /argument must be an integer or a string corresponding to an integer in base 10/))
  end

  it "should raise a ParseError if argument 2 is a string and does not correspond to an integer in base 10" do
    expect { scope.function_convert_base([100,"hex"]) }.to(raise_error(Puppet::ParseError, /argument must be an integer or a string corresponding to an integer in base 10/))
  end

  it "should convert two strings to the correct base" do
    result = scope.function_convert_base(["11",'16'])
    result.should =~ /^[bB]$/
  end
  it "should convert two integers to the correct base" do
    result = scope.function_convert_base([5, 2])
    result.should == '101'
  end
end
