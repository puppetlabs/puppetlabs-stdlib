#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'parseyaml function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = "---\nhunter: washere\ntests: passing\n"
      $o = parseyaml($a)
      $tests = $o['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
    EOS
    it 'parses valid yaml' do
      apply_manifest(pp1, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{tests are "passing"})
      end
    end
  end

  describe 'failure' do
    pp2 = <<-EOS
      $a = "---\nhunter: washere\ntests: passing\n:"
      $o = parseyaml($a, {'tests' => 'using the default value'})
      $tests = $o['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
    EOS
    it 'returns the default value on incorrect yaml' do
      apply_manifest(pp2, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{tests are "using the default value"})
      end
    end

    pp3 = <<-EOS
      $a = "---\nhunter: washere\ntests: passing\n:"
      $o = parseyaml($a)
      $tests = $o['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
    EOS
    it 'raises error on incorrect yaml' do
      apply_manifest(pp3, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{(syntax error|did not find expected key)})
      end
    end

    pp4 = <<-EOS
      $o = parseyaml()
    EOS
    it 'raises error on incorrect number of arguments' do
      apply_manifest(pp4, expect_failures: true) do |r|
        expect(r.stderr).to match(%r{wrong number of arguments}i)
      end
    end
  end
end
