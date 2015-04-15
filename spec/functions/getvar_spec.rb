#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe Puppet::Parser::Functions.function(:getvar) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  describe 'when calling getvar from puppet' do

    it "should not compile when no arguments are passed" do
      skip("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
      Puppet[:code] = '$foo = getvar()'
      expect {
        scope.compiler.compile
      }.to raise_error(Puppet::ParseError, /wrong number of arguments/)
    end

    it "should not compile when too many arguments are passed" do
      skip("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
      Puppet[:code] = '$foo = getvar("foo::bar", "baz", "bar")'
      expect {
        scope.compiler.compile
      }.to raise_error(Puppet::ParseError, /wrong number of arguments/)
    end

    it "should lookup variables in other namespaces" do
      skip("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
      Puppet[:code] = <<-'ENDofPUPPETcode'
        class site::data { $foo = 'baz' }
        include site::data
        $foo = getvar("site::data::foo")
        if $foo != 'baz' {
          fail("getvar did not return what we expect. Got: '${foo}'. Expected: 'baz'.")
        }
      ENDofPUPPETcode
      scope.compiler.compile
    end

    it "should use the given default if available" do
      skip("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
      Puppet[:code] = <<-'ENDofPUPPETcode'
        $foo = getvar("dne::data::foo", "test_default")
        if $foo != 'test_default' {
          fail("getvar did not return what we expect. Got: '${foo}'. Expected: 'test_default'")
        }
      ENDofPUPPETcode
      scope.compiler.compile
    end

   it "should use false if the value is defined" do
     skip("Fails on 2.6.x, see bug #15912") if Puppet.version =~ /^2\.6\./
     Puppet[:code] = <<-'ENDofPUPPETcode'
       class site::data { $foo = false }
       include site::data
       $foo = getvar("site::data::foo", true)
       if $foo != false {
         fail("getvar did not return what we expect. Got: '${foo}'. Expected: false.")
       }
       ENDofPUPPETcode
     scope.compiler.compile
   end

  end
end
