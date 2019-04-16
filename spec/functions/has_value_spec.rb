require 'spec_helper'

describe 'stdlib::has_value' do
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::has_value' expects 2 arguments, got none}) }
  it { is_expected.to run.with_params({}).and_raise_error(ArgumentError, %r{'stdlib::has_value' expects 2 arguments, got 1}) }
  it { is_expected.to run.with_params({}, 'a', 'b').and_raise_error(ArgumentError, %r{'stdlib::has_value' expects 2 arguments, got 3}) }
  it { is_expected.to run.with_params([], 'a').and_raise_error(ArgumentError, %r{'stdlib::has_value' parameter 'h' expects a Hash value, got Array}) }
  it { is_expected.to run.with_params({ 'a' => 1 }, 1).and_return(true) }
  it { is_expected.to run.with_params({ 'a' => 1 }, 2).and_return(false) }
  it { is_expected.to run.with_params({ 'a' => [1] }, [1]).and_return(true) }
end
