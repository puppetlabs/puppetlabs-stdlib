#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'suffix function' do
  describe 'success' do
    pp1 = <<-EOS
      $o = suffix(['a','b','c'],'p')
      notice(inline_template('suffix is <%= @o.inspect %>'))
    EOS
    it 'suffixes array of values' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{suffix is \["ap", "bp", "cp"\]})
      end
    end

    pp2 = <<-EOS
      $o = suffix([],'p')
      notice(inline_template('suffix is <%= @o.inspect %>'))
    EOS
    it 'suffixs with empty array' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{suffix is \[\]})
      end
    end

    pp3 = <<-EOS
      $o = suffix(['a','b','c'], undef)
      notice(inline_template('suffix is <%= @o.inspect %>'))
    EOS
    it 'suffixs array of values with undef' do
      apply_manifest(pp3, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{suffix is \["a", "b", "c"\]})
      end
    end
  end
  describe 'failure' do
    it 'fails with no arguments'
    it 'fails when first argument is not array'
    it 'fails when second argument is not string'
  end
end
