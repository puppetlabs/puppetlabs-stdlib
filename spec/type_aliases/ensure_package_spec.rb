# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Ensure::Package' do
  describe 'valid handling' do
    [
      'present',
      'absent',
      'purged',
      'disabled',
      'installed',
      'latest',
      '1',
      '1.1',
      '>=6.0',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'No complex types can match' do
    context 'Garbage inputs, no complex or non string types can match' do
      [
        1,
        1.1,
        [1.1],
        '',
        { 'foo' => 'bar' },
        {},
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
