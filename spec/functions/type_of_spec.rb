#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe 'type_of', :if => Puppet.version.to_f >= 4.0 do
  it 'gives the type of a string' do
    expect(subject.call_function('type_of', 'hello world')).to be_kind_of(Puppet::Pops::Types::PStringType)
  end

  it 'gives the type of an integer' do
    expect(subject.call_function('type_of', 5)).to be_kind_of(Puppet::Pops::Types::PIntegerType)
  end
end
