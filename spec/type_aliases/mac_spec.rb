# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::MAC' do
  describe 'valid handling' do
    [
      '00:a0:1f:12:7f:a0',
      '00:A0:1F:12:7F:A0',
      '00-A0-1F-12-7F-A0',
      '80:00:02:09:fe:80:00:00:00:00:00:00:00:24:65:ff:ff:91:a3:12',
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid path handling' do
    context 'with garbage inputs' do
      [
        nil,
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
        'one',
        '00:00:00:00:00:0g',
        "\n00:a0:1f:12:7f:a0",
        "\n00:a0:1f:12:7f:a0\n",
        "00:a0:1f:12:7f:a0\n",
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
