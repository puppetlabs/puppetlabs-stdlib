#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'validate_array function' do
  describe 'success' do
    pp1 = <<-EOS
      $one = ['a', 'b']
      validate_array($one)
    EOS
    it 'validates a single argument' do
      apply_manifest(pp1, catch_failures: true)
    end

    pp2 = <<-EOS
      $one = ['a', 'b']
      $two = [['c'], 'd']
      validate_array($one,$two)
    EOS
    it 'validates an multiple arguments' do
      apply_manifest(pp2, catch_failures: true)
    end
    [
      %{validate_array({'a' => 'hash' })},
      %{validate_array('string')},
      %{validate_array(false)},
      %{validate_array(undef)},
    ].each do |pp|
      it "rejects #{pp.inspect}" do
        expect(apply_manifest(pp, expect_failures: true).stderr).to match(%r{is not an Array\.  It looks to be a})
      end
    end
  end
  describe 'failure' do
    it 'handles improper number of arguments'
  end
end
