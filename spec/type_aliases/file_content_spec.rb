# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::File::Content' do
  describe 'valid content' do
    [
      '',
      'abc',
      sensitive('secret'),
      # TODO: test Deferred and Binary?
    ].each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end

    context 'with garbage inputs' do
      [
        nil,
        1,
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
