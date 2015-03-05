#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'file_exists_array function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    it 'file_exists_array /etc/passwd exists' do
      pp = <<-EOS
      $a = ['/etc/passwd']
      $b = ['/etc/passwd']
      $o = file_exists_array($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'file_exists_array /etc/passwd exists, /no_file doesnt' do
      pp = <<-EOS
      $a = ['/etc/passwd', '/no_file']
      $b = ['/etc/passwd']
      $o = file_exists_array($a)
      if $o == $b {
        notify { 'output correct': }
      }
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/Notice: output correct/)
      end
    end

    it 'file_exists_array no one exists' do
      pp = <<-EOS
      $a = ['/no_file', '/another_no_file']
      $b = []
      $o = file_exists_array($a)
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
