#!/usr/bin/env rspec
require 'spec_helper'
require 'facter'

describe Puppet::Parser::Functions.function(:has_interface_with) do
# Pulled from Dan's create_resources function
def get_scope
  @topscope = Puppet::Parser::Scope.new
  # This is necessary so we don't try to use the compiler to discover our parent.
  @topscope.parent = nil
  @scope = Puppet::Parser::Scope.new
  @scope.compiler = Puppet::Parser::Compiler.new(Puppet::Node.new("floppy", :environment => 'production'))
  @scope.parent = @topscope
  @compiler = @scope.compiler
end

describe 'the has_interface_with function' do

  before :all do
    Puppet::Parser::Functions.autoloader.loadall
  end

  before :each do
    @scope = Puppet::Parser::Scope.new
    Facter.loadfacts
  end

  it "should exist" do
    #puts Facter.fact(:interfaces).value
    get_scope
    Puppet::Parser::Functions.function('has_interface_with').should == 'function_has_interface_with'
  end

  it "should have loopback" do
    result = @scope.function_has_interface_with(['lo'])
    result.should(eq(true)) # This is only true on Linux
  end
end
end
