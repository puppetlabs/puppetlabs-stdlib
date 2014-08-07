#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe Puppet::Parser::Functions.function(:resources_deep_merge) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    expect(Puppet::Parser::Functions.function("resources_deep_merge")).to eq("function_resources_deep_merge")
  end

  it "should raise an ArgumentError if there is less than 1 arguments" do
    expect { scope.function_resources_deep_merge([]) }.to( raise_error(ArgumentError))
  end

  it "should not compile when 1 argument is passed" do
    my_hash={'one' => 1}
    expect { scope.function_resources_deep_merge([my_hash]) }.to( raise_error(ArgumentError))
  end

  it 'should require all parameters are hashes' do
    expect { scope.function_resources_deep_merge([{}, '2']) }.to( raise_error(ArgumentError))
  end

  describe 'when calling resources_deep_merge on a resource and a defaults hash' do
    it 'should be able to deep_merge a resource hash and a defaults hash' do
      resources = {
        'one' => {
          'attributes' => {
            'user' => '1',
            'pass' => '1'
          }
        },
        'two' => {
          'attributes' => {
            'user' => '2',
            'pass' => '2'
          }
        }
      }
      defaults = {
        'ensure' => 'present',
        'attributes' => {
          'type' => 'psql'
        }
      }
      result = scope.function_resources_deep_merge([resources, defaults])
      result['one'].should == {'ensure' => 'present', 'attributes' => {'type'=>'psql', 'user' => '1', 'pass' => '1'}}
      result['two'].should == {'ensure' => 'present', 'attributes' => {'type'=>'psql', 'user' => '2', 'pass' => '2'}}
    end
  end

end
