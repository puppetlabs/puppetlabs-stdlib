# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Compat::Bool' do
  describe 'accepts booleans' do
    [
      true,
      false,
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [
      [1],
      [{}],
      [true],
      'true',
      'false',
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
