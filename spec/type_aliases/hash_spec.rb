# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Compat::Hash' do
  describe 'accepts hashes' do
    [
      {},
      { 'one' => 'two' },
      { 'wan' => 3 },
      { '001' => 'helly' },
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
  describe 'rejects other values' do
    [
      '',
      'one',
      '1',
      [],
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
