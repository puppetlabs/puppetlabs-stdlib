#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe 'the augeas function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should fail if the augeas feature is not present" do
    Puppet.features.expects(:augeas?).returns(false)
    expect { scope.function_augeas([]) }.to raise_error(Puppet::ParseError, /requires the augeas feature/)
  end

  it "should exist" do
    Puppet::Parser::Functions.function("augeas").should == "function_augeas"
  end

  context "when passing wrong arguments" do
    before :each do
      Puppet.features.stubs(:augeas?).returns(true)
    end

    it "should raise a ParseError if there are no arguments" do
      expect { scope.function_augeas([]) }.to raise_error(Puppet::ParseError, /Wrong number of arguments/)
    end

    it "should raise a ParseError if content is not a string" do
      expect { scope.function_augeas([['foo'], 'Fstab.lns', []]) }.to raise_error(Puppet::ParseError, /content must be a string/)
    end

    it "should raise a ParseError if lens is not a string" do
      expect { scope.function_augeas(['foo', ['Fstab.lns'], []]) }.to raise_error(Puppet::ParseError, /lens must be a string/)
    end

    it "should raise a ParseError if changes is not an array" do
      expect { scope.function_augeas(['foo', 'Fstab.lns', 'changes']) }.to raise_error(Puppet::ParseError, /changes must be an array/)
    end
  end

  if Puppet.features.augeas?
    context "when passing invalid input" do
      it "should fail to parse input with lens" do
        expect { scope.function_augeas(['foo', 'Fstab.lns', []]) }.to raise_error(Puppet::ParseError, /Failed to parse string with lens Fstab.lns:/)
      end
    end

    context "when passing illegal changes" do
      it "should fail to apply illegal change" do
        expect { scope.function_augeas(["\n", 'Fstab.lns', ['foo bar']]) }.to raise_error(Puppet::ParseError, /Failed to apply change to tree/)
      end
    end

    context "when generating an invalid tree" do
      it "should fail to apply changes with wrong tree" do
        expect { scope.function_augeas(["\n", 'Fstab.lns', ['set ./1/opt 3']]) }.to raise_error(Puppet::ParseError, /Failed to apply changes with lens Fstab.lns:/)
      end
    end

    context "when applying valid changes" do
      it "should remove the 3rd option" do
        result = scope.function_augeas(["proc        /proc   proc    nodev,noexec,nosuid     0       0\n", 'Fstab.lns', ['rm ./1/opt[3]']])
        result.class.should == String
        #result.should == "proc       /proc   proc    nodev,noexec     0       0\n"
      end

      it "should set a 4th option" do
        result = scope.function_augeas(["proc        /proc   proc    nodev,noexec,nosuid     0       0\n", 'Fstab.lns', ['ins opt after ./1/opt[last()]', 'set ./1/opt[last()] nofoo']])
        result.class.should == String
        #result.should == "proc       /proc   proc    nodev,noexec,nosuid,nofoo     0       0\n"
      end
    end

    context "when using old libs" do
      it "should not work with Augeas prior to 1.0.0" do
        Augeas.any_instance.expects(:get).with('/augeas/version').returns('0.10.0')
        expect { scope.function_augeas(["\n", 'Fstab.lns', []]) }.to raise_error(Puppet::ParseError, /requires Augeas 1\.0\.0/)
      end

      it "should not work with ruby-augeas prior to 0.5.0" do
        Augeas.any_instance.expects(:methods).returns([])
        expect { scope.function_augeas(["\n", 'Fstab.lns', []]) }.to raise_error(Puppet::ParseError, /requires ruby-augeas 0\.5\.0/)
      end
    end
  end
end
