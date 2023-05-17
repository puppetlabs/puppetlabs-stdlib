# frozen_string_literal: true

require 'spec_helper'

describe 'PE Version specs' do
  # we mock calls for the puppetversion fact, it is not normal to expect nil responses when mocking.
  RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
  context 'when puppetversion is nil' do
    before :each do
      allow(Facter.fact(:puppetversion)).to receive(:value).and_return(nil)
    end

    it 'puppetversion is nil' do
      expect(Facter.fact(:puppetversion).value).to be_nil
    end

    it 'pe_version is nil' do
      expect(Facter.fact(:pe_version).value).to be_nil
    end
  end

  context 'when PE is installed' do
    ['2.6.1', '2.10.300'].each do |version|
      puppetversion = "2.7.19 (Puppet Enterprise #{version})"
      context "puppetversion => #{puppetversion}" do
        before :each do
          allow(Facter).to receive(:value).with(anything).and_call_original
          allow(Facter).to receive(:value).with('puppetversion').and_return(puppetversion)
        end

        (major, minor, patch) = version.split('.')

        it 'returns true' do
          expect(Facter.fact(:is_pe).value).to be(true)
        end

        it "has a version of #{version}" do
          expect(Facter.fact(:pe_version).value).to eq(version)
        end

        it "has a major version of #{major}" do
          expect(Facter.fact(:pe_major_version).value).to eq(major)
        end

        it "has a minor version of #{minor}" do
          expect(Facter.fact(:pe_minor_version).value).to eq(minor)
        end

        it "has a patch version of #{patch}" do
          expect(Facter.fact(:pe_patch_version).value).to eq(patch)
        end
      end
    end
  end

  context 'when PE is not installed' do
    before :each do
      allow(Facter.fact(:puppetversion)).to receive(:value).and_return('2.7.19')
    end

    it 'is_pe is false' do
      expect(Facter.fact(:is_pe).value).to be(false)
    end

    it 'pe_version is nil' do
      expect(Facter.fact(:pe_version).value).to be_nil
    end

    it 'pe_major_version is nil' do
      expect(Facter.fact(:pe_major_version).value).to be_nil
    end

    it 'pe_minor_version is nil' do
      expect(Facter.fact(:pe_minor_version).value).to be_nil
    end

    it 'has a patch version' do
      expect(Facter.fact(:pe_patch_version).value).to be_nil
    end
  end
end
