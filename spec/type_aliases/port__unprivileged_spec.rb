# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Port::Unprivileged' do
  describe 'valid unprivilegedport' do
    [
      1024,
      1337,
      65_000,
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid path handling' do
    context 'garbage inputs' do
      [
        nil,
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
        'https',
        '443',
        -1,
        80,
        443,
        1023,
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
