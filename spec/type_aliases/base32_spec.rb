# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Base32' do
  describe 'valid handling' do
    ['ASDASDDASD3453453', 'ASDASDDASD3453453=', 'ASDASDDASD3453453==', 'ASDASDDASD3453453===', 'ASDASDDASD3453453====', 'ASDASDDASD3453453=====', 'ASDASDDASD3453453======', 'asdasddasd3453453',
     'asdasddasd3453453=', 'asdasddasd3453453==', 'asdasddasd3453453===', 'asdasddasd3453453====', 'asdasddasd3453453=====', 'asdasddasd3453453======'].each do |value|
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
        "\nASDASDDASD3453453",
        "\nASDASDDASD3453453\n",
        "ASDASDDASD3453453\n",
        '',
        'asdasd!@#$',
        '=asdasd9879876876+/',
        'asda=sd9879876876+/',
        'asdaxsd9879876876+/===',
        'asdads asdasd',
        'asdasddasd3453453=======',
        'asdaSddasd',
        'asdasddasd1',
        'asdasddasd9',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
