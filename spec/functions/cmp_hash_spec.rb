# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::cmp_hash' do
  it { is_expected.not_to be_nil }

  describe 'raise exception unless two Hashes are provided' do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::cmp_hash' expects 2 arguments, got none}) }
    it { is_expected.to run.with_params({}).and_raise_error(ArgumentError, %r{'stdlib::cmp_hash' expects 2 arguments, got 1}) }
    it { is_expected.to run.with_params({}, {}, {}).and_raise_error(ArgumentError, %r{'stdlib::cmp_hash' expects 2 arguments, got 3}) }
    it { is_expected.to run.with_params({}, 1).and_raise_error(ArgumentError, %r{'stdlib::cmp_hash' parameter 'hash2' expects a Hash value, got Integer}) }
    it { is_expected.to run.with_params({}, 'a').and_raise_error(ArgumentError, %r{'stdlib::cmp_hash' parameter 'hash2' expects a Hash value, got String}) }
    it { is_expected.to run.with_params(:undef, {}).and_raise_error(ArgumentError, %r{'stdlib::cmp_hash' parameter 'hash1' expects a Hash value, got Undef}) }
  end

  describe 'raise exception in case lambda expects wrong number of arguments' do
    it 'one too few' do
      expect(subject).to run \
        .with_params({}, {}) \
        .with_lambda { 1 } \
        .and_raise_error(ArgumentError, Regexp.new(Regexp.escape('rejected: block expects 1 argument, got none')))
    end

    # TODO: Does not pass Rubocop tests, because running the function with this kind of lambda does not throw an error.
    # it 'one too many' do
    #   expect(subject).to run \
    #     .with_params({}, {}) \
    #     .with_lambda { |_, _| 1 } \
    #     .and_raise_error(ArgumentError, Regexp.new(Regexp.escape('rejected: block expects 1 argument, got 2')))
    # end
  end

  hash1 = {
    'primary_key' => 2,
    'key1' => ['val1', 'val2'],
    'key2' => { 'key3' => 'val3' },
    'key4' => true,
    'key5' => 123
  }
  hash2 = {
    'primary_key' => 1,
    'key6' => ['val1', 'val2'],
    'key7' => { 'key8' => 'val9' },
    'key10' => true,
    'key11' => 456
  }
  describe 'compare without block' do
    it { is_expected.to run.with_params(hash1, hash2).and_return(-1) }
    it { is_expected.to run.with_params(hash2, hash1).and_return(1) }
    it { is_expected.to run.with_params({}, hash1).and_return(-1) }
    it { is_expected.to run.with_params(hash1, hash1).and_return(0) }
  end

  describe 'compare with block' do
    it {
      expect(subject).to run \
        .with_params(hash1, hash2) \
        .with_lambda { |hsh| hsh['primary_key'] } \
        .and_return(1)
    }
  end
end
