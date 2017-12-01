#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'parsejson function' do
  describe 'success' do
    pp1 = <<-EOS
      $a = '{"hunter": "washere", "tests": "passing"}'
      $ao = parsejson($a)
      $tests = $ao['tests']
      notice(inline_template('tests are <%= @tests.inspect %>'))
    EOS
    it 'parses valid json' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{tests are "passing"})
      end
    end
  end

  describe 'failure' do
    pp2 = <<-EOS
      $a = '{"hunter": "washere", "tests": "passing",}'
      $ao = parsejson($a, 'tests are using the default value')
      notice(inline_template('a is <%= @ao.inspect %>'))
    EOS
    it 'raises error on incorrect json - default value is used' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{tests are using the default value})
      end
    end

    pp3 = <<-EOS
      $a = '{"hunter": "washere", "tests": "passing",}'
      $ao = parsejson($a)
      notice(inline_template('a is <%= @ao.inspect %>'))
    EOS
    it 'raises error on incorrect json' do
      apply_manifest(pp3, :expect_failures => true) do |r|
        expect(r.stderr).to match(%r{expected next name})
      end
    end

    pp4 = <<-EOS
      $o = parsejson()
    EOS
    it 'raises error on incorrect number of arguments' do
      apply_manifest(pp4, :expect_failures => true) do |r|
        expect(r.stderr).to match(%r{wrong number of arguments}i)
      end
    end
  end
end
