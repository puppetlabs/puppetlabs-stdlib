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
    let(:root_ent) { "FIXME TBD on Windows" }
    let(:expected_root_home) { "FIXME TBD on Windows" }

    it "should return FIXME TBD on windows" do
      pending "FIXME: TBD on windows"
      Facter::Util::Resolution.expects(:exec).with("getent passwd root").returns(root_ent)
      Facter::Util::RootHome.get_root_home.should == expected_root_home
    end
  end
end
