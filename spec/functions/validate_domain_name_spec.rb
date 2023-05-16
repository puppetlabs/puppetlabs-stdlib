# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::validate_domain_name' do
  describe 'signature validation' do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  end

  describe 'valid inputs' do
    it { is_expected.to run.with_params('com', 'com.') }
    it { is_expected.to run.with_params('x.com', 'x.com.') }
    it { is_expected.to run.with_params('foo.example.com', 'foo.example.com.') }
    it { is_expected.to run.with_params('2foo.example.com', '2foo.example.com.') }
    it { is_expected.to run.with_params('www.2foo.example.com', 'www.2foo.example.com.') }
    it { is_expected.to run.with_params('domain.tld', 'puppet.com') }
    it { is_expected.to run.with_params('www.example.2com') }
    it { is_expected.to run.with_params('10.10.10.10.10') }
  end

  describe 'invalid inputs' do
    it { is_expected.to run.with_params([]).and_raise_error(ArgumentError, %r{got Array}) }
    it { is_expected.to run.with_params({}).and_raise_error(ArgumentError, %r{got Hash}) }
    it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, %r{got Integer}) }
    it { is_expected.to run.with_params(true).and_raise_error(ArgumentError, %r{got Boolean}) }

    it { is_expected.to run.with_params('foo.example.com', []).and_raise_error(ArgumentError, %r{got Array}) }
    it { is_expected.to run.with_params('foo.example.com', {}).and_raise_error(ArgumentError, %r{got Hash}) }
    it { is_expected.to run.with_params('foo.example.com', 1).and_raise_error(ArgumentError, %r{got Integer}) }
    it { is_expected.to run.with_params('foo.example.com', true).and_raise_error(ArgumentError, %r{got Boolean}) }

    it { is_expected.to run.with_params('').and_raise_error(ArgumentError, %r{got ''}) }
    it { is_expected.to run.with_params('invalid domain').and_raise_error(ArgumentError, %r{got 'invalid domain'}) }
    it { is_expected.to run.with_params('-foo.example.com').and_raise_error(ArgumentError, %r{got '-foo\.example\.com'}) }
  end
end
