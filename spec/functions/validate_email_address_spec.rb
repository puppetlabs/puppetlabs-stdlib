# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::validate_email_address' do
  describe 'signature validation' do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  end

  describe 'valid inputs' do
    it { is_expected.to run.with_params('bob@gmail.com') }
    it { is_expected.to run.with_params('alice+puppetlabs.com@gmail.com') }
  end

  describe 'invalid inputs' do
    it { is_expected.to run.with_params({}).and_raise_error(ArgumentError, %r{got Hash}) }
    it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, %r{got Integer}) }
    it { is_expected.to run.with_params(true).and_raise_error(ArgumentError, %r{got Boolean}) }
    it { is_expected.to run.with_params('one').and_raise_error(ArgumentError, %r{got 'one'}) }
    it { is_expected.to run.with_params('bob@gmail.com', {}).and_raise_error(ArgumentError, %r{got Hash}) }
    it { is_expected.to run.with_params('bob@gmail.com', true).and_raise_error(ArgumentError, %r{got Boolean}) }
    it { is_expected.to run.with_params('bob@gmail.com', 'one').and_raise_error(ArgumentError, %r{got 'one'}) }
  end
end
