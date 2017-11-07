#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'pick_default function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = undef
      $o = pick_default($a, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'pick_defaults a default value' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{picked is "default"})
      end
    end

    pp2 = <<-EOS
      $a = undef
      $b = undef
      $o = pick_default($a,$b)
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'pick_defaults with no value' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{picked is ""})
      end
    end

    pp3 = <<-EOS
      $a = "something"
      $b = "long"
      $o = pick_default($a, $b, 'default')
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'pick_defaults the first set value' do
      apply_manifest(pp3, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{picked is "something"})
      end
    end
  end
  describe 'failure' do
    pp4 = <<-EOS
      $o = pick_default()
      notice(inline_template('picked is <%= @o.inspect %>'))
    EOS
    it 'raises error with no values' do
      apply_manifest(pp4, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{Must receive at least one argument})
      end
    end
  end
end
