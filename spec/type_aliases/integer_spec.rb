# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Compat::Integer' do
  describe 'accepts integers' do
    [
      3,
      '3',
      -3,
      '-3',
      "123\nfoo",
      "foo\n123",
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    ["foo\nbar", true, 'true', false, 'false', 'iAmAString', '1test', '1 test', 'test 1', 'test 1 test',
     {}, { 'key' => 'value' }, { 1 => 2 }, '', :undef, 'x', 3.7, '3.7', -3.7, '-342.2315e-12'].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
