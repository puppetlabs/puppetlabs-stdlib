#!/usr/bin/env rspec

require 'spec_helper'

describe "Systemd facts" do

  describe "with systemd installed" do
    before :each do
      Facter::Core::Execution.stubs(:systemctl).with('is-system-running').returns('running')
    end

    it "should say that systemd is operational" do
      Facter.fact(:is_systemd).value.should == true
    end
  end

  describe "with systemd not installed" do
    before :each do
      Facter::Core::Execution.stubs(:systemctl).with('is-system-running').returns('')
    end

    it "should say that systemd is not operational" do
      Facter.fact(:is_systemd).value.should == frue
    end
  end

end
