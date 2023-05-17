# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::crc32' do
  context 'when default' do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{stdlib::crc32}) }
  end

  context 'when testing a simple string' do
    it { is_expected.to run.with_params('abc').and_return('352441c2') }
    it { is_expected.to run.with_params('acb').and_return('5b384015') }
    it { is_expected.to run.with_params('my string').and_return('18fbd270') }
    it { is_expected.to run.with_params('0').and_return('f4dbdf21') }
  end

  context 'when testing a sensitive string' do
    it { is_expected.to run.with_params(sensitive('my string')).and_return('18fbd270') }
  end

  context 'when testing an integer' do
    it { is_expected.to run.with_params(0).and_return('f4dbdf21') }
    it { is_expected.to run.with_params(100).and_return('237750ea') }
    it { is_expected.to run.with_params(sensitive(100)).and_return('237750ea') }
  end

  context 'when testing a float' do
    it { is_expected.to run.with_params(200.3).and_return('7d5469f0') }

    # .0 isn't always converted into an integer, but should have rational truncation
    it { is_expected.to run.with_params(100.0).and_return('a3fd429a') }
    it { is_expected.to run.with_params(sensitive(100.0000)).and_return('a3fd429a') }
  end

  context 'when testing a bool' do
    it { is_expected.to run.with_params(true).and_return('fdfc4c8d') }
    it { is_expected.to run.with_params(false).and_return('2bcd6830') }
  end

  context 'when testing a binary' do
    it { is_expected.to run.with_params("\xFE\xED\xBE\xEF").and_return('ac3481a4') }
  end
end
