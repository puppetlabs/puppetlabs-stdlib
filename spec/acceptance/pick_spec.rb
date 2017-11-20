#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'pick function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = undef
      $o = pick($a, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'picks a default value' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{picked is "default"})
      end
    end

    pp2 = <<-EOS
      $a = "something"
      $b = "long"
      $o = pick($a, $b, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'picks the first set value' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{picked is "something"})
      end
    end
  end

  describe 'failure' do
    pp3 = <<-EOS
      $a = undef
      $b = undef
      $o = pick($a, $b)
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'raises error with all undef values' do
      apply_manifest(pp3, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{must receive at least one non empty value})
      end
    end
  end
end
