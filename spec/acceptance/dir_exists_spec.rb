#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'dir_exists function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'dir_exists /etc exists' do
      pp = <<-EOS
      $a = '/etc'
      $b = true
      $o = dir_exists($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'dir_exists /no_dir does not exist' do
      pp = <<-EOS
      $a = '/no_dir'
      $b = false
      $o = dir_exists($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-strings'
  end
end
