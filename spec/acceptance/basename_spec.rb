#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'basename function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    context 'absolute path' do
      it 'returns the basename' do
        pp = <<-EOS
        $a = '/path/to/a/file.txt'
        $b = 'file.txt'
        $o = basename($a)
        if $o == $b {
          notify { 'output correct': }
        }
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/Notice: output correct/)
        end
      end
    end
    context 'relative path' do
      it 'returns the basename' do
        pp = <<-EOS
        $a = 'path/to/a/file.txt'
        $b = 'file.txt'
        $o = basename($a)
        if $o == $b {
          notify { 'output correct': }
        }
        EOS

        apply_manifest(pp, :catch_failures => true) do |r|
          expect(r.stdout).to match(/Notice: output correct/)
        end
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
