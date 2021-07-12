# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Compat::String' do
  describe 'accepts strings' do
    [
      '',
      'one',
      nil,
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end

  describe 'rejects other values' do
    [
      [],
      {},
      1,
      true,
    ].each do |value|
      describe value.inspect do
        it { is_expected.not_to allow_value(value) }
      end
    end
  end
end
