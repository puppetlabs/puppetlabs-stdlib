# coding: utf-8

require 'spec_helper'

describe 'Stdlib::Yes_no' do
  describe 'valid types' do
    [
      'yes',
      'no',
      'YES',
      'Yes',
      'NO',
      'No',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid types' do
    context 'with garbage inputs' do
      [
        true,
        false,
        :keyword,
        nil,
        ['yes', 'no'],
        { 'foo' => 'bar' },
        {},
        '',
        'ネット',
        '55555',
        '0x123',
        'yess',
        'nooo',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
