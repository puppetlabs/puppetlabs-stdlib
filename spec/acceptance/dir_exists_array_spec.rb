#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'dir_exists_array function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'dir_exists_array /etc exists' do
      pp = <<-EOS
      $a = ['/etc']
      $b = ['/etc']
      $o = dir_exists_array($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'dir_exists_array /etc exists, /no_dir doesnt' do
      pp = <<-EOS
      $a = ['/etc', '/no_dir']
      $b = ['/etc']
      $o = dir_exists_array($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'dir_exists_array no one exists' do
      pp = <<-EOS
      $a = ['/no_dir', '/another_no_dir']
      $b = []
      $o = dir_exists_array($a)
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
