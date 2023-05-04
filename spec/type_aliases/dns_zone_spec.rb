# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Dns::Zone' do
  describe 'accepts dns zones' do
    [
      '.',
      'com.',
      'example.com.',
      '10.10.10.10.10.',
      'xn--5ea.pf.',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [
      true,
      false,
      '',
      'iAmAString',
      {},
      { 'key' => 'value' },
      { 1 => 2 },
      :undef,
      3,
      'www..com.',
      '127.0.0.1',
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
