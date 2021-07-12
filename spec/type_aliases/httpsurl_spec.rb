# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::HTTPSUrl' do
  describe 'valid handling' do
    ['https://hello.com', 'https://notcreative.org', 'https://notexciting.co.uk', 'https://graphemica.com/❤', 'https://graphemica.com/緩', 'HTTPS://FOO.com'].each do |value|
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
        "\nhttps://hello.com",
        "\nhttps://hello.com\n",
        "https://hello.com\n",
        'httds://notquiteright.org',
        'hptts:/nah',
        'https;//notrightbutclose.org',
        'http://graphemica.com/❤',
        'http://graphemica.com/緩',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
