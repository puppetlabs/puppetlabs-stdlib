#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'delete_at function' do
  describe 'success' do
    pp = <<-EOS
      $output = delete_at(['a','b','c','b'], 1)
      if $output == ['a','c','b'] {
        notify { 'output correct': }
      }
    EOS
    it 'deletes elements of the array' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
end
