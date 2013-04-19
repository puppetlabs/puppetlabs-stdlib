#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the coalesce function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  subject do
    function_name = Puppet::Parser::Functions.function(:coalesce)
    scope.method(function_name)
  end

  it "should exist" do
    Puppet::Parser::Functions.function("coalesce").should == "function_coalesce"
  end

  it "should return first non-zero-length string" do
    subject.call(['first', 'second']).should eq('first')
    subject.call(['', 'second']).should eq('second')
  end

  it "should return the first non-empty array" do
    subject.call([ ['first'], ['second'] ]).should eq(['first'])
    subject.call([ [], ['second'] ]).should eq(['second'])
  end

  it "should return the first non-empty hash" do
    subject.call([ {'first' => 'a'}, {'second' => 'b'} ]).should eq({'first' => 'a'})
    subject.call([ {}, {'second' => 'b'} ]).should eq({'second' => 'b'})
  end
end
