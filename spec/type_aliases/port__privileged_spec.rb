# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Port::Privileged' do
  describe 'valid ports' do
    [
      80,
      443,
      1023,
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
        1337,
        1024,
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
