#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'reject function' do
  describe 'success' do
    pp1 = <<-EOS
      $o = reject(['aaa','bbb','ccc','aaaddd'], 'aaa')
      notice(inline_template('reject is <%= @o.inspect %>'))
    EOS
    it 'rejects array of values' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{reject is \["bbb", "ccc"\]})
      end
    end

    pp2 = <<-EOS
      $o = reject([],'aaa')
      notice(inline_template('reject is <%= @o.inspect %>'))
    EOS
    it 'rejects with empty array' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{reject is \[\]})
      end
    end

    pp3 = <<-EOS
      $o = reject(['aaa','bbb','ccc','aaaddd'], undef)
      notice(inline_template('reject is <%= @o.inspect %>'))
    EOS
    it 'rejects array of values with undef' do
      apply_manifest(pp3, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{reject is \[\]})
      end
    end
  end
  describe 'failure' do
    it 'fails with no arguments'
    it 'fails when first argument is not array'
    it 'fails when second argument is not string'
  end
end
