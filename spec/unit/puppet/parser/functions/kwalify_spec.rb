#!/usr/bin/env rspec
require 'spec_helper'

describe "the kwalify function" do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
  end

  it "should exist" do
    Puppet::Parser::Functions.function("kwalify").should == "function_kwalify"
  end

  it "should raise a ParseError if there is less than 2 arguments" do
    lambda { @scope.function_kwalify([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should validate a simple array schema" do
    schema = { 
      'type' => 'seq',
      'sequence' => [
        { 'type' => 'str' }
      ]
    }
    document = ['a','b','c']
    @scope.function_kwalify([schema, document])
  end

  it "should not validate a simple array schema when invalid" do
    schema = { 
      'type' => 'seq',
      'sequence' => [
        { 'type' => 'str' }
      ]
    }
    document = ['a','b',{'a' => 'b'}]
    lambda { @scope.function_kwalify([schema, document]) }.should(raise_error(Puppet::ParseError))
  end

  it "should validate a hash schema" do
    schema = {
      'type' => 'map',
      'mapping' => {
        'key1' => {
          'type' => 'str',
        },
        'key2' => {
          'type' => 'str',
        },
      }
    }
    document = {
      'key1' => 'b',
      'key2' => 'c',
    }
    @scope.function_kwalify([schema, document])
  end

end
