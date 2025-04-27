# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::File::Mode' do
  describe 'valid modes' do
    [
      '7',
      '12',
      '666',

      '0000',
      '0644',
      '1644',
      '2644',
      '4644',
      '0123',
      '0777',

      'a=,o-r,u+X,g=w',
      'a=Xr,+0',
      'u=rwx,g+rX',
      'u+s,g-s',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid modes' do
    context 'with garbage inputs' do
      [
        true,
        false,
        :keyword,
        nil,
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
        "\n0644",
        "\n0644\n",
        "0644\n",
        'ネット',
        '55555',
        '0x123',
        '0649',

        '=8,X',
        'x=r,a=wx',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
