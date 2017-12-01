#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'empty function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = ''
      $b = true
      $o = empty($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'recognizes empty strings' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-EOS
      $a = 'aoeu'
      $b = false
      $o = empty($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'recognizes non-empty strings' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp3 = <<-EOS
      $a = 7
      $b = false
      $o = empty($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'handles numerical values' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-strings'
  end
end
