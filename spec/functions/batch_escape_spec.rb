# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::batch_escape' do
  it { is_expected.not_to be_nil }

  describe 'signature validation' do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::batch_escape' expects 1 argument, got none}) }
    it { is_expected.to run.with_params('foo', 'bar').and_raise_error(ArgumentError, %r{'stdlib::batch_escape' expects 1 argument, got 2}) }
  end

  describe 'stringification' do
    it { is_expected.to run.with_params(10).and_return('"10"') }
    it { is_expected.to run.with_params(false).and_return('"false"') }
  end

  describe 'escaping' do
    it { is_expected.to run.with_params('foo').and_return('"foo"') }
    it { is_expected.to run.with_params('foo bar').and_return('"foo bar"') }

    it {
      expect(subject).to run.with_params('~`!@#$%^&*()_-=[]\{}|;\':",./<>?')
                            .and_return('"~`!@#\\$%^&*()_-=[]\\\{}|;\':"",./<>?"')
    }
  end
end
