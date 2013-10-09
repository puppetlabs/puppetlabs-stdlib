#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'rspec-puppet'

in_array = ['London', 'Paris', 'New York', 'Barnsley']

describe 'random_element' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  describe 'argument handling' do

    it 'fails with no arguments' do
      lambda { scope.function_random_element([]) }.should( raise_error(Puppet::ParseError))
    end

    it 'should raise TypeError on string input' do
      lambda { scope.function_random_element(['string']) }.should( raise_error(TypeError))
    end

    it 'should not raise TypeError on array input' do
      lambda { scope.function_random_element([in_array]) }.should_not( raise_error(TypeError))
    end

  end

  describe 'functionality' do

    it 'should return a string' do
      result = scope.function_random_element([in_array])
      result = result.class.name
      result.should(eq('String'))
    end

    it 'should return random array member' do
      result = scope.function_random_element([in_array])
      in_array.should(include(result))
    end

  end

end
