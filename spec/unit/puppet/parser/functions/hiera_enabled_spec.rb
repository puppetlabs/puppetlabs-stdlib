require 'spec_helper'

describe Puppet::Parser::Functions.function(:hiera_enabled) do
  before :each do
    @scope = Puppet::Parser::Scope.new
  end
  it "should fail if hiera is not installed" do
    Puppet.features.stubs(:hiera?).returns false
    Puppet::Parser::Functions.stubs(:function).with(:hiera).returns false
    @scope.function_hiera_enabled([]).should be_false
  end
  it "should fail if hiera is not installed but the function, hiera(), is available" do
    Puppet.features.stubs(:hiera?).returns false
    Puppet::Parser::Functions.stubs(:function).with(:hiera).returns true
    @scope.function_hiera_enabled([]).should be_false
  end
  it "should fail if hiera is installed but the function, hiera(), is not available" do
    Puppet.features.stubs(:hiera?).returns true
    Puppet::Parser::Functions.stubs(:function).with(:hiera).returns false
    @scope.function_hiera_enabled([]).should be_false
  end
  it "should succeed if hiera is installed and the function, hiera(), is available" do
    Puppet.features.stubs(:hiera?).returns true
    Puppet::Parser::Functions.stubs(:function).with(:hiera).returns true
    @scope.function_hiera_enabled([]).should be_true
  end
end
