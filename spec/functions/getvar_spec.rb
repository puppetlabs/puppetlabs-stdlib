require 'spec_helper'

describe 'getvar' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

  context 'given variables in namespaces' do
    let(:pre_condition) {
      <<-'ENDofPUPPETcode'
      class site::data { $foo = 'baz' }
      include site::data
      ENDofPUPPETcode
    }

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

    it { is_expected.to run.with_params('site::data::foo').and_return('baz') }
    it { is_expected.to run.with_params('::site::data::foo').and_return('baz') }

    context 'with strict variable checking', :if => RSpec.configuration.strict_variables do
      it { is_expected.to run.with_params('::site::data::bar').and_raise_error(ArgumentError, /undefined_variable/) }
    end

    context 'without strict variable checking', :unless => RSpec.configuration.strict_variables do
      it { is_expected.to run.with_params('::site::data::bar').and_return(nil) }
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
