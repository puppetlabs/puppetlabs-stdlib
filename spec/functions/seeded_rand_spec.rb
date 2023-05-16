# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::seeded_rand' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::seeded_rand' expects 2 arguments, got none}i) }
  it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, %r{'stdlib::seeded_rand' expects 2 arguments, got 1}i) }
  it { is_expected.to run.with_params(0, '').and_raise_error(ArgumentError, %r{parameter 'max' expects an Integer\[1\] value, got Integer\[0, 0\]}) }
  it { is_expected.to run.with_params(1.5, '').and_raise_error(ArgumentError, %r{parameter 'max' expects an Integer value, got Float}) }
  it { is_expected.to run.with_params(-10, '').and_raise_error(ArgumentError, %r{parameter 'max' expects an Integer\[1\] value, got Integer\[-10, -10\]}) }
  it { is_expected.to run.with_params('string', '').and_raise_error(ArgumentError, %r{parameter 'max' expects an Integer value, got String}) }
  it { is_expected.to run.with_params([], '').and_raise_error(ArgumentError, %r{parameter 'max' expects an Integer value, got Array}) }
  it { is_expected.to run.with_params({}, '').and_raise_error(ArgumentError, %r{parameter 'max' expects an Integer value, got Hash}) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(ArgumentError, %r{parameter 'seed' expects a String value, got Integer}) }
  it { is_expected.to run.with_params(1, []).and_raise_error(ArgumentError, %r{parameter 'seed' expects a String value, got Array}) }
  it { is_expected.to run.with_params(1, {}).and_raise_error(ArgumentError, %r{parameter 'seed' expects a String value, got Hash}) }

  context 'produce predictible and reproducible results' do
    it { is_expected.to run.with_params(20, 'foo').and_return(1) }
    it { is_expected.to run.with_params(100, 'bar').and_return(35) }
    it { is_expected.to run.with_params(1000, 'ǿňè').and_return(247) }
    it { is_expected.to run.with_params(1000, '文字列').and_return(67) }
  end
end
