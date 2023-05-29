# frozen_string_literal: true

require 'spec_helper'

describe 'hash_values' do
  # please note that these tests are examples only
  # you will need to replace the params and return value
  # with your expectations
  it { is_expected.to run.with_params({}).and_return([]) }
  it { is_expected.to run.with_params({ 'key' => 'value' }).and_return(['value']) }
  it { is_expected.to run.with_params({ 'key' => { 'key1' => 'value1', 'key2' => 'value2' } }).and_return(['value1', 'value2']) }
  it { is_expected.to run.with_params(2).and_raise_error(StandardError) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
