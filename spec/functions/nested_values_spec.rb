# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::nested_values' do
  it { is_expected.to run.with_params({}).and_return([]) }
  it { is_expected.to run.with_params({ 'key' => 'value' }).and_return(['value']) }
  it { is_expected.to run.with_params({ 'key' => { 'key1' => 'value1', 'key2' => 'value2' } }).and_return(['value1', 'value2']) }
  it { is_expected.to run.with_params({ 'key1' => 'value1', 'key2' => { 'key1' => 'value21', 'key2' => 'value22' }, 'key3' => 'value3' }).and_return(['value1', 'value21', 'value22', 'value3']) }
  it { is_expected.to run.with_params(2).and_raise_error(StandardError) }
  it { is_expected.to run.with_params(nil).and_raise_error(StandardError) }
end
