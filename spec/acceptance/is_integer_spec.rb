#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_integer function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = ['aaa.com','bbb','ccc']
      $b = false
      $o = is_integer($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_integers arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-EOS
      $a = true
      $b = false
      $o = is_integer($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_integers true' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp3 = <<-EOS
      $a = "3"
      $b = true
      $o = is_integer($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_integers strings' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp4 = <<-EOS
      $a = 3.5
      $b = false
      $o = is_integer($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_integers floats' do
      apply_manifest(pp4, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp5 = <<-EOS
      $a = 3
      $b = true
      $o = is_integer($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_integers integers' do
      apply_manifest(pp5, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp6 = <<-EOS
      $a = {'aaa'=>'www.com'}
      $b = false
      $o = is_integer($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_integers hashes' do
      apply_manifest(pp6, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-arrays'
  end
end
