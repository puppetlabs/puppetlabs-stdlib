#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'delete_values function' do
  describe 'success' do
    pp = <<-EOS
      $a = { 'a' => 'A', 'b' => 'B', 'B' => 'C', 'd' => 'B' }
      $b = { 'a' => 'A', 'B' => 'C' }
      $o = delete_values($a, 'B')
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'deletes elements of the hash' do
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles non-hash arguments'
    it 'handles improper argument counts'
  end
end
