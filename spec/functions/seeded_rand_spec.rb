# frozen_string_literal: true

require 'spec_helper'

describe 'seeded_rand' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(0, '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params(1.5, '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params(-10, '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params('-10', '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params('string', '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params([], '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params({}, '').and_raise_error(ArgumentError, %r{first argument must be a positive integer}) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(ArgumentError, %r{second argument must be a string}) }
  it { is_expected.to run.with_params(1, []).and_raise_error(ArgumentError, %r{second argument must be a string}) }
  it { is_expected.to run.with_params(1, {}).and_raise_error(ArgumentError, %r{second argument must be a string}) }

  context 'produce predictible and reproducible results' do
    it { is_expected.to run.with_params(20, 'foo').and_return(1) }
    it { is_expected.to run.with_params(100, 'bar').and_return(35) }
    it { is_expected.to run.with_params(1000, 'ǿňè').and_return(247) }
    it { is_expected.to run.with_params(1000, '文字列').and_return(67) }
  end
end
