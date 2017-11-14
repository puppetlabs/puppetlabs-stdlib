#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'getvar function' do
  describe 'success' do
    pp = <<-EOS
      class a::data { $foo = 'aoeu' }
      include a::data
      $b = 'aoeu'
      $o = getvar("a::data::foo")
      if $o == $b {
        notify { 'output correct': }
      }
    EOS
    it 'getvars from classes' do
      apply_manifest(pp, catch_failures: true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
