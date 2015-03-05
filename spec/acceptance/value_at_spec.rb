#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'value_at function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'returns a value' do
      pp = <<-EOS
      $arg = {
        'a' => 1,
        'b' => 2,
        'c' => 3,
      }
      $output = value_at($arg, 'a')
      notice(inline_template('<%= @output.inspect %>'))
      EOS

      expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/^1$/)
    end

    it 'returns the default value when key not found' do
      pp = <<-EOS
      $arg = {
        'a' => 1,
        'b' => 2,
        'c' => 3,
      }
      $output = value_at($arg, 'z', 26)
      notice(inline_template('<%= @output.inspect %>'))
      EOS

      expect(apply_manifest(pp, :catch_failures => true).stdout).to match(/^26$/)
    end
  end
  describe 'failure' do
    it 'handles non-hash arguments' do
      pp = <<-EOS
      $arg = "foo"
      $output = value_at($arg, 'a')
      notice(inline_template('<%= @output.inspect %>'))
      EOS

      expect(apply_manifest(pp, :expect_failures => true).stderr).to match(/Requires hash/)
    end
  end
end
