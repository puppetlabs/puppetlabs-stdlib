#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe Puppet::Parser::Functions.function(:getvar) do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  describe 'when calling getvar from puppet' do

    it "should not compile when no arguments are passed" do
      Puppet[:code] = 'getvar()'
      expect { scope.compiler.compile }.should raise_error(Puppet::ParseError, /wrong number of arguments/)
    end
    it "should not compile when too many arguments are passed" do
      Puppet[:code] = 'getvar("foo::bar", "baz")'
      expect { scope.compiler.compile }.should raise_error(Puppet::ParseError, /wrong number of arguments/)
    end

    it "should lookup variables in other namespaces" do
      pending "Puppet doesn't appear to think getvar is an rvalue function... BUG?"
      Puppet[:code] = <<-'ENDofPUPPETcode'
        class site::data { $foo = 'baz' }
        include site::data
        $foo = getvar("site::data::foo")
        if $foo != 'baz' {
          fail('getvar did not return what we expect')
        }
      ENDofPUPPETcode
      scope.compiler.compile
    end
  end
end
