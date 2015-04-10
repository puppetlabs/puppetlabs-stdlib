#! /usr/bin/env ruby -S rspec
require 'spec_helper_acceptance'

describe 'fqdn_rand_string function', :unless => UNSUPPORTED_PLATFORMS.include?(fact('operatingsystem')) do
  describe 'success' do
    let(:facts_d) do
      if fact('is_pe', '--puppet') == "true"
        if fact('osfamily') =~ /windows/i
          if fact('kernelmajversion').to_f < 6.0
            'c:/documents and settings/all users/application data/puppetlabs/facter/facts.d'
          else
            'c:/programdata/puppetlabs/facter/facts.d'
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
      #no need to create on windows, pe creates by default
      if fact('osfamily') !~ /windows/i
        shell("mkdir -p '#{facts_d}'")
      end
    end
    it 'generates random alphanumeric strings' do
      shell("echo fqdn=fakehost.localdomain > '#{facts_d}/fqdn.txt'")
      pp = <<-eos
      $l = 10
      $o = fqdn_rand_string($l)
      notice(inline_template('fqdn_rand_string is <%= @o.inspect %>'))
      eos

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/fqdn_rand_string is "7oDp0KOr1b"/)
      end
    end
    it 'generates random alphanumeric strings with custom seeds' do
      shell("echo fqdn=fakehost.localdomain > '#{facts_d}/fqdn.txt'")
      pp = <<-eos
      $l = 10
      $s = 'seed'
      $o = fqdn_rand_string($l, undef, $s)
      notice(inline_template('fqdn_rand_string is <%= @o.inspect %>'))
      eos

      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(/fqdn_rand_string is "3HS4mbuI3E"/)
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers for length argument'
  end
end
