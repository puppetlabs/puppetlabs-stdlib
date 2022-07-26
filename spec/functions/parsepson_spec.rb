# frozen_string_literal: true

require 'spec_helper'

describe 'parsepson' do
  it 'exists' do
    is_expected.not_to eq(nil)
  end

  it 'raises an error if called without any arguments' do
    is_expected.to run.with_params
                      .and_raise_error(%r{'parsepson' expects between 1 and 2 arguments, got none}i)
  end

  context 'with correct PSON data' do
    it 'is able to parse PSON data with a Hash' do
      is_expected.to run.with_params('{"a":"1","b":"2"}')
                        .and_return('a' => '1', 'b' => '2')
    end

    it 'is able to parse PSON data with an Array' do
      is_expected.to run.with_params('["a","b","c"]')
                        .and_return(['a', 'b', 'c'])
    end

    it 'is able to parse empty PSON values' do
      actual_array = ['[]', '{}']
      expected = [[], {}]
      actual_array.each_with_index do |actual, index|
        is_expected.to run.with_params(actual).and_return(expected[index])
      end
    end

    it 'is able to parse PSON data with a mixed structure' do
      is_expected.to run.with_params('{"a":"1","b":2,"c":{"d":[true,false]}}')
                        .and_return('a' => '1', 'b' => 2, 'c' => { 'd' => [true, false] })
    end

    it 'is able to parse PSON data with a UTF8 and double byte characters' do
      is_expected.to run.with_params('{"×":"これ","ý":"記号","です":{"©":["Á","ß"]}}')
                        .and_return('×' => 'これ', 'ý' => '記号', 'です' => { '©' => ['Á', 'ß'] })
    end

    it 'does not return the default value if the data was parsed correctly' do
      is_expected.to run.with_params('{"a":"1"}', 'default_value')
                        .and_return('a' => '1')
    end
  end

  context 'with incorrect PSON data' do
    it 'raises an error with invalid PSON and no default' do
      is_expected.to run.with_params('invalid')
                        .and_raise_error(PSON::ParserError)
    end

    it 'returns the default value for an invalid PSON and a given default' do
      is_expected.to run.with_params('invalid', 'default_value')
                        .and_return('default_value')
    end

    it 'supports a structure for a default value' do
      is_expected.to run.with_params('invalid', 'a' => '1')
                        .and_return('a' => '1')
    end
  end
end
