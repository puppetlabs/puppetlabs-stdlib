require 'spec_helper'

describe 'ifelse' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects 3 arguments}i) }
  it { is_expected.to run.with_params('1').and_raise_error(ArgumentError, %r{expects 3 arguments}i) }

  it { is_expected.to run.with_params('false', 'iftrue', 'iffalse').and_raise_error(ArgumentError, %r{parameter 'bool' expects a Boolean value}i) }

  it { is_expected.to run.with_params(false, 'iftrue', 'iffalse').and_return('iffalse') }
  it { is_expected.to run.with_params(true, 'iftrue', 'iffalse').and_return('iftrue') }
  it { is_expected.to run.with_params(true, :undef, 'iffalse').and_return(:undef) }
  it { is_expected.to run.with_params(true, nil, 'iffalse').and_return(nil) }
end
