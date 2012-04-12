#!/usr/bin/env ruby -S rspec
require 'spec_helper'

describe Puppet::Parser::Functions.function(:has_interface_with) do
  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  let(:scope) do
    scope = Puppet::Parser::Scope.new
  end

  # The subject of these examples is the method itself.
  subject do
    scope.method :function_has_interface_with
  end

  # We need to mock out the Facts so we can specify how we expect this function
  # to behave on different platforms.
  context "On Mac OS X Systems" do
    before :each do
      scope.expects(:lookupvar).with("interfaces").returns('lo0,gif0,stf0,en1,p2p0,fw0,en0,vmnet1,vmnet8,utun0')
    end
    it 'should have loopback (lo0)' do
      subject.call(['lo0']).should be_true
    end
    it 'should not have loopback (lo)' do
      subject.call(['lo']).should be_false
    end
  end
  context "On Linux Systems" do
    before :each do
      scope.expects(:lookupvar).with("interfaces").returns('eth0,lo')
    end
    it 'should have loopback (lo)' do
      subject.call(['lo']).should be_true
    end
    it 'should not have loopback (lo0)' do
      subject.call(['lo0']).should be_false
    end
  end
end
