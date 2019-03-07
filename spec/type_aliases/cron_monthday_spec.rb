# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Cron::Monthday' do
  describe 'accept integers' do
    [1, 2, 10, 15, 31].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept integers as strings' do
    ['1', '2', '10', '15', '31'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept ranges' do
    ['1-31', '1-15', '15-31', '20-25'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept step values' do
    ['1-31/2', '1-31/31', '15-31/3'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept wildcards' do
    ['*', '*-15', '*/15'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept comma-separated integers, ranges and step values' do
    ['1,8,15,22', '1-7,16-21', '1-15/2,16-31/3', '1,8-15,16-31/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept arrays of valid expressions' do
    [
      [1, 8, 15, 22, 29],
      [1, '8', 15, '22', 29],
      ['1-20', '21-31'],
      ['*'],
      ['*/2', '*/7'],
      ['*/7', 7],
      ['1-31', 31],
      ['*/5', '6-9', 31],
    ].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'reject leading zeroes in integers and ranges' do
    ['01', '02', '03', '04', '05', '06', '07', '08', '09', '1-02', '1,2,03'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject leading zeroes in step values' do
    ['*/01', '*/02', '*/03', '*/04', '*/05', '*/06', '*/07', '*/08', '*/09'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject out of range integers' do
    [0, '0', 32, '32', '0-31', '1-32', '0-31/5', '1-32/5', '*/0', '*/32', '0,1,2', '30,31,32'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject incorrect values' do
    ['', [], [''], '1,', '1,2,', '*/*', 'foo'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
