# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::sort_by' do
  it { is_expected.not_to be_nil }

  describe 'raise exception with inappropriate parameters' do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, Regexp.new('expects 1 argument, got none')) }
    it { is_expected.to run.with_params([]).and_raise_error(ArgumentError, Regexp.new('expects a block')) }
    it { is_expected.to run.with_params(:undef).and_raise_error(ArgumentError, Regexp.new("rejected: parameter 'ary' expects an Array value, got Undef")) }
    it { is_expected.to run.with_params(true).and_raise_error(ArgumentError, Regexp.new("rejected: parameter 'ary' expects an Array value, got Boolean")) }
    it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, Regexp.new("rejected: parameter 'ary' expects an Array value, got Integer")) }
    it { is_expected.to run.with_params({}).with_lambda { 1 }.and_raise_error(ArgumentError, Regexp.new('block expects between 1 and 2 arguments, got none')) }
  end

  # Puppet's each iterator considers Integers, Strings, Arrays and Hashes to be Iterable.
  unordered_array = ['The', 'quick', 'brown', 'fox', 'jumps', 'over', 'the', 'lazy', 'dog']
  ordered_array = ['The', 'brown', 'dog', 'fox', 'jumps', 'lazy', 'over', 'quick', 'the']
  unordered_hash = { 'The' => 'quick', 'brown' => 'fox', 'jumps' => 'over', 'the' => 'lazy', 'dog' => '.' }
  ordered_hash = { 'dog' => '.', 'brown' => 'fox', 'the' => 'lazy', 'jumps' => 'over', 'The' => 'quick' }
  unordered_string = 'The quick brown fox jumps over the lazy dog.'
  ordered_string = '        .Tabcdeeefghhijklmnoooopqrrstuuvwxyz'

  describe 'with sane input' do
    it 'does sort Array' do
      expect(subject).to run \
        .with_params(unordered_array) \
        .with_lambda { |e| e } \
        .and_return(ordered_array)
    end

    it 'does sort Hash by entry' do
      expect(subject).to run \
        .with_params(unordered_hash) \
        .with_lambda { |e| e[1] } \
        .and_return(ordered_hash)
    end

    it 'does sort Hash by key-value pairs' do
      expect(subject).to run \
        .with_params(unordered_hash) \
        .with_lambda { |_, v| v } \
        .and_return(ordered_hash)
    end

    it 'does sort String' do
      expect(subject).to run \
        .with_params(unordered_string) \
        .with_lambda { |e| e } \
        .and_return(ordered_string)
    end
  end
end
