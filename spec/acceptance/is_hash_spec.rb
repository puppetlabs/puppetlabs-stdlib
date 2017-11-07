#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_hash function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = ['aaa','bbb','ccc']
      $o = is_hash($a)
      notice(inline_template('is_hash is <%= @o.inspect %>'))
    EOS
    it 'is_hashs arrays' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{is_hash is false})
      end
    end

    pp2 = <<-EOS
      $a = {}
      $b = true
      $o = is_hash($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_hashs empty hashs' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp3 = <<-EOS
      $a = "aoeu"
      $b = false
      $o = is_hash($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_hashs strings' do
      apply_manifest(pp3, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp4 = <<-EOS
      $a = {'aaa'=>'bbb'}
      $b = true
      $o = is_hash($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_hashs hashes' do
      apply_manifest(pp4, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
