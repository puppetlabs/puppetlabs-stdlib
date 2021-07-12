# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Windowspath' do
  describe 'valid handling' do
    ['C:\\', 'C:\\WINDOWS\\System32', 'C:/windows/system32', 'X:/foo/bar', 'X:\\foo\\bar', '\\\\host\\windows', 'X:/var/ůťƒ8', 'X:/var/ネット'].each do |value|
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
        "\nC:\\",
        "\nC:\\\n",
        "C:\\\n",
        '',
        'httds://notquiteright.org',
        '/usr2/username/bin:/usr/local/bin:/usr/bin:.',
        'C;//notright/here',
        'C:noslashes',
        'C:ネット',
        'C:ůťƒ8',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
