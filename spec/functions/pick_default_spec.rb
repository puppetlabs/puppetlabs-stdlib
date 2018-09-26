require 'spec_helper'

describe 'pick_default' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(RuntimeError, %r{Must receive at least one argument}) }

  it { is_expected.to run.with_params('one', 'two').and_return('one') }
  it { is_expected.to run.with_params('ớņệ', 'ťωơ').and_return('ớņệ') }
  it { is_expected.to run.with_params('', 'two').and_return('two') }
  it { is_expected.to run.with_params(:undef, 'two').and_return('two') }
  it { is_expected.to run.with_params(:undefined, 'two').and_return('two') }
  it { is_expected.to run.with_params(nil, 'two').and_return('two') }

  ['', :undef, :undefined, nil, {}, [], 1, 'default'].each do |value|
    describe "when providing #{value.inspect} as default" do
      it { is_expected.to run.with_params('one', value).and_return('one') }
      it { is_expected.to run.with_params('ớņệ', value).and_return('ớņệ') }
      it { is_expected.to run.with_params([], value).and_return([]) }
      it { is_expected.to run.with_params({}, value).and_return({}) }
      it { is_expected.to run.with_params(value, value).and_return(mapped_value(value)) }
      it { is_expected.to run.with_params(:undef, value).and_return(mapped_value(value)) }
      it { is_expected.to run.with_params(:undefined, value).and_return(mapped_value(value)) }
      it { is_expected.to run.with_params(nil, value).and_return(mapped_value(value)) }
    end
  end

  if Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0
    def mapped_value(v)
      v
    end
  else
    def mapped_value(v)
      # Puppet 6.0.0 will always map arguments the same way as the Puppet Language
      # even if function is called from Ruby via call_function
      # The 3x function API expects nil and :undef to be represented as empty string
      (v.nil? || v == :undef) ? '' : v
    end
  end
end
