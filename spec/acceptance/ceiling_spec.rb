#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'ceiling function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = 12.8
      $b = 13
      $o = ceiling($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'ceilings floats' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-EOS
      $a = 7
      $b = 7
      $o = ceiling($a)
      if $o == $b {
        notify { 'output is correct': }
      }
    EOS
    it 'ceilings integers' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output is correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
