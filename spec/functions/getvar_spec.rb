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

    it { is_expected.to run.with_params('site::data::foo').and_return('baz') }
    it { is_expected.to run.with_params('::site::data::foo').and_return('baz') }

    context 'with strict variable checking', :if => RSpec.configuration.strict_variables do
      it { is_expected.to run.with_params('::site::data::bar').and_raise_error(ArgumentError, /undefined_variable/) }
    end

    context 'without strict variable checking', :unless => RSpec.configuration.strict_variables do
      it { is_expected.to run.with_params('::site::data::bar').and_return(nil) }
    end
  end
end
