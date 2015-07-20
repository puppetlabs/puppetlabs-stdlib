#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'fqdn_rotate function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    let(:facts_d) do
      puppet_version = (on default, puppet('--version')).output.chomp
      if puppet_version < '4.0.0' && fact('is_pe', '--puppet') == "true"
        if fact('osfamily') =~ /windows/i
          if fact('kernelmajversion').to_f < 6.0
            'C:/Documents and Settings/All Users/Application Data/PuppetLabs/facter/facts.d'
          else
            'C:/ProgramData/PuppetLabs/facter/facts.d'
          end
        else
          '/etc/puppetlabs/facter/facts.d'
        end
      else
        '/etc/facter/facts.d'
      end
    end
    after :each do
      shell("if [ -f '#{facts_d}/fqdn.txt' ] ; then rm '#{facts_d}/fqdn.txt' ; fi")
    end
    before :each do
      #No need to create on windows, PE creates by default
      if fact('osfamily') !~ /windows/i
        shell("mkdir -p '#{facts_d}'")
      end
    end
    it 'rotates arrays' do
      shell("echo fqdn=fakehost.localdomain > '#{facts_d}/fqdn.txt'")
      pp = <<-EOS
      $a = ['a','b','c','d']
      $o = fqdn_rotate($a)
      notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/fqdn_rotate is \["d", "a", "b", "c"\]/)
      end
    end
    it 'rotates arrays with custom seeds' do
      shell("echo fqdn=fakehost.localdomain > '#{facts_d}/fqdn.txt'")
      pp = <<-EOS
      $a = ['a','b','c','d']
      $s = 'seed'
      $o = fqdn_rotate($a, $s)
      notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/fqdn_rotate is \["c", "d", "a", "b"\]/)
      end
    end
    it 'rotates strings' do
      shell("echo fqdn=fakehost.localdomain > '#{facts_d}/fqdn.txt'")
      pp = <<-EOS
      $a = 'abcd'
      $o = fqdn_rotate($a)
      notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/fqdn_rotate is "dabc"/)
      end
    end
    it 'rotates strings with custom seeds' do
      shell("echo fqdn=fakehost.localdomain > '#{facts_d}/fqdn.txt'")
      pp = <<-EOS
      $a = 'abcd'
      $s = 'seed'
      $o = fqdn_rotate($a, $s)
      notice(inline_template('fqdn_rotate is <%= @o.inspect %>'))
      EOS

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/fqdn_rotate is "cdab"/)
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles invalid arguments'
  end
end
