# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Compat::Numeric' do
  describe 'accepts numerics' do
    [
      3,
      '3',
      -3,
      '-3',
      3.7,
      '3.7',
      -3.7,
      '-342.2315e-12',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [true, 'true', false, 'false', 'iAmAString', '1test', '1 test', 'test 1', 'test 1 test', {}, { 'key' => 'value' }, { 1 => 2 }, '', :undef, 'x'].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
