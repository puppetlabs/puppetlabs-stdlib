#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'is_domain_name function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = ['aaa.com','bbb','ccc']
      $o = is_domain_name($a)
      notice(inline_template('is_domain_name is <%= @o.inspect %>'))
    EOS
    it 'is_domain_names arrays' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_domain_name is false})
      end
    end

    pp2 = <<-EOS
      $a = true
      $o = is_domain_name($a)
      notice(inline_template('is_domain_name is <%= @o.inspect %>'))
    EOS
    it 'is_domain_names true' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_domain_name is false})
      end
    end

    pp3 = <<-EOS
      $a = false
      $o = is_domain_name($a)
      notice(inline_template('is_domain_name is <%= @o.inspect %>'))
    EOS
    it 'is_domain_names false' do
      apply_manifest(pp3, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_domain_name is false})
      end
    end

    pp4 = <<-EOS
      $a = "3foo-bar.2bar-fuzz.com"
      $b = true
      $o = is_domain_name($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_domain_names strings with hyphens' do
      apply_manifest(pp4, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp5 = <<-EOS
      $a = "-bar.2bar-fuzz.com"
      $b = false
      $o = is_domain_name($a)
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'is_domain_names strings beginning with hyphens' do
      apply_manifest(pp5, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp6 = <<-EOS
      $a = {'aaa'=>'www.com'}
      $o = is_domain_name($a)
      notice(inline_template('is_domain_name is <%= @o.inspect %>'))
    EOS
    it 'is_domain_names hashes' do
      apply_manifest(pp6, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{is_domain_name is false})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-arrays'
  end
end
