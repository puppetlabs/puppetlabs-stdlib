#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'ensure_packages function', :unless => (UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) || fact('osfamily') == 'windows') do
  describe 'success' do
    it 'ensure_packages a package' do
      apply_manifest('package { "rake": ensure => absent, provider => "gem", }')
      pp = <<-EOS
      $a = "rake"
      ensure_packages($a,{'provider' => 'gem'})
      EOS

      apply_manifest(pp, :expect_changes => true)
    end
    it 'ensures a package already declared'
    it 'takes defaults arguments'
  end
  describe 'failure' do
    it 'handles no arguments'
    it 'handles non strings'
  end
end
