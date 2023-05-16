# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::ensure_packages' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params('packagename') }
  it { is_expected.to run.with_params(['packagename1', 'packagename2']) }

  context 'when given a catalog with "package { puppet: ensure => absent }"' do
    let(:pre_condition) { 'package { puppet: ensure => absent }' }

    describe 'after running ensure_package("facter")' do
      before(:each) { subject.execute('facter') }

      # this lambda is required due to strangeness within rspec-puppet's expectation handling
      it { expect(-> { catalogue }).to contain_package('puppet').with_ensure('absent') }
      it { expect(-> { catalogue }).to contain_package('facter').with_ensure('installed') }
    end

    describe 'after running ensure_package("facter", { "provider" => "gem" })' do
      before(:each) { subject.execute('facter', 'provider' => 'gem') }

      # this lambda is required due to strangeness within rspec-puppet's expectation handling
      it { expect(-> { catalogue }).to contain_package('puppet').with_ensure('absent').without_provider }
      it { expect(-> { catalogue }).to contain_package('facter').with_ensure('installed').with_provider('gem') }
    end
  end

  context 'when given hash of packages' do
    before(:each) do
      subject.execute({ 'foo' => { 'provider' => 'rpm' }, 'bar' => { 'provider' => 'gem' } }, 'ensure' => 'present')
      subject.execute('パッケージ' => { 'ensure' => 'absent' })
      subject.execute('ρǻ¢κầģẻ' => { 'ensure' => 'absent' })
      subject.execute(
        {
          'package_one' => {},
          'package_two' => {},
          'package_three' => { 'provider' => 'puppetserver_gem' }
        },
        { 'provider' => 'puppet_gem' },
      )
    end

    # this lambda is required due to strangeness within rspec-puppet's expectation handling
    it { expect(-> { catalogue }).to contain_package('foo').with('provider' => 'rpm', 'ensure' => 'installed') }
    it { expect(-> { catalogue }).to contain_package('bar').with('provider' => 'gem', 'ensure' => 'installed') }

    context 'with UTF8 and double byte characters' do
      it { expect(-> { catalogue }).to contain_package('パッケージ').with('ensure' => 'absent') }
      it { expect(-> { catalogue }).to contain_package('ρǻ¢κầģẻ').with('ensure' => 'absent') }
    end

    describe 'default attributes' do
      it 'package specific attributes take precedence' do
        expect(-> { catalogue }).to contain_package('package_one').with('provider' => 'puppet_gem')
        expect(-> { catalogue }).to contain_package('package_two').with('provider' => 'puppet_gem')
        expect(-> { catalogue }).to contain_package('package_three').with('provider' => 'puppetserver_gem')
      end
    end
  end

  context 'when given a catalog with "package { puppet: ensure => installed }"' do
    let(:pre_condition) { 'package { puppet: ensure => installed }' }

    describe 'after running ensure_package("puppet", { "ensure" => "present" })' do
      before(:each) { subject.execute('puppet', 'ensure' => 'present') }

      # this lambda is required due to strangeness within rspec-puppet's expectation handling
      it { expect(-> { catalogue }).to contain_package('puppet').with_ensure('installed') }
    end
  end

  context 'when given a catalog with "package { puppet: ensure => present }"' do
    let(:pre_condition) { 'package { puppet: ensure => present }' }

    describe 'after running ensure_package("puppet", { "ensure" => "present" })' do
      before(:each) { subject.execute('puppet', 'ensure' => 'present') }

      it { expect(-> { catalogue }).to contain_package('puppet').with_ensure('present') }
    end

    describe 'after running ensure_package("puppet", { "ensure" => "installed" })' do
      before(:each) { subject.execute('puppet', 'ensure' => 'installed') }

      it { expect(-> { catalogue }).to contain_package('puppet').with_ensure('present') }
    end

    describe 'after running ensure_package(["puppet"])' do
      before(:each) { subject.execute(['puppet']) }

      it { expect(-> { catalogue }).to contain_package('puppet').with_ensure('present') }
    end
  end
end
