require 'spec_helper'

describe "the pry function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function('pry')).to eq('function_pry')
  end
end
