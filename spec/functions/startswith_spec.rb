# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::start_with' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects 2 arguments, got none}i) }
  it { is_expected.to run.with_params('').and_raise_error(ArgumentError, %r{expects 2 arguments, got 1}) }

  it { is_expected.to run.with_params('', 'foo').and_return(false) }
  it { is_expected.to run.with_params('foobar', 'foo').and_return(true) }
  it { is_expected.to run.with_params('foObar', ['bar', 'baz']).and_return(false) }
end
