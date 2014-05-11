#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the to_yaml function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("to_yaml").should == "function_to_yaml"
  end

  it "should raise a ParseError if there is less than 1 arguments" do
    lambda { scope.function_to_yaml([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should convert a data structure to YAML" do
    yaml_data = {
      'string' => 'a string',
      'array' => ['aaa', 'bbb', 'ccc' ],
      'bool' => true,
      'hash' => {
        'string' => 'indeed it is',
        'another_string' => 'quite so'
      },
    }
    result = scope.function_to_yaml([yaml_data])
    result.should(eq("#{yaml_data.to_yaml}"))
  end
end
