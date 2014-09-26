require 'spec_helper'
require 'json'
describe "dump_args" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dump_args").should == "function_dump_args"
  end

end
