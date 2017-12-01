#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'values function' do
  describe 'success' do
    pp1 = <<-EOS
      $arg = {
        'a' => 1,
        'b' => 2,
        'c' => 3,
      }
      $output = values($arg)
      notice(inline_template('<%= @output.sort.inspect %>'))
    EOS
    it 'returns an array of values' do
      expect(apply_manifest(pp1, :catch_failures => true).stdout).to match(%r{\[1, 2, 3\]})
    end
  end

  describe 'failure' do
    pp2 = <<-EOS
      $arg = "foo"
      $output = values($arg)
      notice(inline_template('<%= @output.inspect %>'))
    EOS
    it 'handles non-hash arguments' do
      expect(apply_manifest(pp2, :expect_failures => true).stderr).to match(%r{Requires hash})
    end
  end
end
