#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'file_exists function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'file_exists /etc/passwd exists' do
      pp = <<-EOS
      $a = '/etc/passwd'
      $b = true
      $o = file_exists($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'file_exists /no_file does not exist' do
      pp = <<-EOS
      $a = '/no_file'
      $b = false
      $o = file_exists($a)
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
    it 'handles non-arrays'
  end
end
