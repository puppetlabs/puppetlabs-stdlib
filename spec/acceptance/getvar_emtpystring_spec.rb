#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'getvar_emptystring function' do
  describe 'success' do
    it 'getvars from classes' do
      pp = <<-EOS
      class a::data { $foo = 'aoeu' }
      include a::data
      $b = 'aoeu'
      $o = getvar_emptystring("a::data::foo")
      if $o == $b {
        notify { 'output correct': }
      }
      $z = getvar_emptystring("a::data::bar")
      if $z == '' {
        notify { 'empty string when not found': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
        expect(r.stdout).to match(/Notice: empty string when not found/)
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
