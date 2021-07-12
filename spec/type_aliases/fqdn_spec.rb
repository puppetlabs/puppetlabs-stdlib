# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Fqdn' do
  describe 'valid handling' do
    ['example', 'example.com', 'www.example.com'].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'invalid path handling' do
    context 'garbage inputs' do
      [
        [nil],
        [nil, nil],
        { 'foo' => 'bar' },
        {},
        '',
        "\nexample",
        "\nexample\n",
        "example\n",
        '2001:DB8::1',
        'www www.example.com',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
