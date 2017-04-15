#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the keyval_to_resources function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("keyval_to_resources").should == "function_keyval_to_resources"
  end

  it "should raise argumenterror if less than two args supplied" do
    lambda { scope.function_keyval_to_resources({'a' => 'b'}).should( raise_error(ArgumentError))}
  end

  it "should raise argumenterror if first argument is not a hash" do
    lambda { scope.function_keyval_to_resources('string1', 'string2').should( raise_error(ArgumentError))}
  end

  it "should return a structured hash" do
    result = scope.function_keyval_to_resources([{'variable' => 'value'}, 'attribute'])
    result.should(eq({'variable' => { 'attribute' => 'value' }}))
  end
end
