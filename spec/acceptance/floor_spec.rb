#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'floor function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = 12.8
      $b = 12
      $o = floor($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'floors floats' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-EOS
      $a = 7
      $b = 7
      $o = floor($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'floors integers' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
