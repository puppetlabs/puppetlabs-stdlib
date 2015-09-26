#! /usr/bin/env ruby -S rspec
require 'spec_helper'
require 'puppet/type'
require 'puppet/type/package'

describe 'package_provider', :type => :fact do
  before { Facter.clear }
  after { Facter.clear }

  context "darwin" do
    it "should return pkgdmg" do
      provider = Puppet::Type.type(:package).provider(:pkgdmg)
      Puppet::Type.type(:package).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:package_provider).value).to eq('pkgdmg')
    end
  end

  context "centos 7" do
    it "should return yum" do
      provider = Puppet::Type.type(:package).provider(:yum)
      Puppet::Type.type(:package).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:package_provider).value).to eq('yum')
    end
  end

  context "ubuntu" do
    it "should return apt" do
      provider = Puppet::Type.type(:package).provider(:apt)
      Puppet::Type.type(:package).stubs(:defaultprovider).returns provider

      expect(Facter.fact(:package_provider).value).to eq('apt')
    end
  end

end
