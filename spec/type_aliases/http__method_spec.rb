# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Http::Method' do
  describe 'valid HTTP Methods' do
    [
      'HEAD',
      'GET',
      'PUT',
      'DELETE',
      'TRACE',
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
        'Ok',
        'get',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
