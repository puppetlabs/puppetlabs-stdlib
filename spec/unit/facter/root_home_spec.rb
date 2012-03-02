require 'spec_helper'
require 'facter/root_home'

describe Facter::Util::RootHome do
  context "solaris" do
    let(:root_ent) { "root:x:0:0:Super-User:/:/sbin/sh" }
    let(:expected_root_home) { "/" }

    it "should return /" do
      Facter::Util::Resolution.expects(:exec).with("getent passwd root").returns(root_ent)
      Facter::Util::RootHome.get_root_home.should == expected_root_home
    end
  end
  context "linux" do
    let(:root_ent) { "root:x:0:0:root:/root:/bin/bash" }
    let(:expected_root_home) { "/root" }

    it "should return /root" do
      Facter::Util::Resolution.expects(:exec).with("getent passwd root").returns(root_ent)
      Facter::Util::RootHome.get_root_home.should == expected_root_home
    end
  end
  context "macosx" do
    let(:root_ent) { "root:*:0:0:System Administrator:/var/root:/bin/sh" }
    let(:expected_root_home) { "/var/root" }

    it "should return /var/root" do
      Facter::Util::Resolution.expects(:exec).with("getent passwd root").returns(root_ent)
      Facter::Util::RootHome.get_root_home.should == expected_root_home
    end
  end
  context "windows" do
    let(:program_data)   { ENV['ProgramData'] || "C:\\ProgramData" }
    let(:local_app_data) { ENV['LOCALAPPDATA'] || "C:\\Users\\albert\\Appdata\\Local" }
    let(:temp)           { ENV['TEMP'] || "C:\\Users\\albert\\Appdata\\Local\\Temp" }

    before :each do
      Facter.clear
      Facter.fact(:kernel).expects(:value).returns("windows")
    end

    it "should return %ProgramData% on windows" do
      # Call the memoized methods before setting expectations.  This is
      # necessary to use the "REAL" values when running the spec tests on a
      # windows system.
      program_data
      ENV.expects(:[]).with('ProgramData').returns(program_data)
      Facter.fact(:root_home).value.should eql program_data
    end
    it "should fall back to %LOCALAPPDATA%" do
      # Call the memoized methods before setting expectations.  This is
      # necessary to use the "REAL" values when running the spec tests on a
      # windows system.
      local_app_data
      ENV.expects(:[]).with('ProgramData').returns(nil)
      ENV.expects(:[]).with('LOCALAPPDATA').returns(local_app_data)
      Facter.fact(:root_home).value.should eql local_app_data
    end
    it "should fall back to %TEMP%" do
      # Call the memoized methods before setting expectations.  This is
      # necessary to use the "REAL" values when running the spec tests on a
      # windows system.
      temp
      ENV.expects(:[]).with('ProgramData').returns(nil)
      ENV.expects(:[]).with('LOCALAPPDATA').returns(nil)
      ENV.expects(:[]).with('TEMP').returns(temp)
      Facter.fact(:root_home).value.should eql temp
    end
  end
end
