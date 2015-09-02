#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'try_get_value function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'try_get_valuees a value' do
      pp = <<-EOS
      $data = {
        'a' => { 'b' => 'passing'}
      }

      $tests = try_get_value($a, 'a/b')
      notice(inline_template('tests are <%= @tests.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/tests are "passing"/)
      end
    end
  end
  describe 'failure' do
    it 'uses a default value' do
      pp = <<-EOS
      $data = {
        'a' => { 'b' => 'passing'}
      }

      $tests = try_get_value($a, 'c/d', 'using the default value')
      notice(inline_template('tests are <%= @tests.inspect %>'))
      EOS

      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stdout).to match(/using the default value/)
      end
    end

    it 'raises error on incorrect number of arguments' do
      pp = <<-EOS
      $o = try_get_value()
      EOS

      apply_manifest(pp, :expect_failures => true) do |r|
        expect(r.stderr).to match(/wrong number of arguments/i)
      end
    end
  end
end
