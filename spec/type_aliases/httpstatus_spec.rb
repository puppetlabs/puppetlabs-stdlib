# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::HttpStatus' do
  describe 'valid HTTP Status' do
    [
      200,
      302,
      404,
      418,
      503,
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
        '199',
        600,
        1_000,
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
