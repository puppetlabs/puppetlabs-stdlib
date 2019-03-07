# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Cron::Hour' do
  describe 'accept integers' do
    [0, 1, 2, 15, 23].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept integers as strings' do
    ['0', '1', '2', '15', '23'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept ranges' do
    ['0-23', '0-5', '18-23', '5-11', '19-22'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept step values' do
    ['0-23/2', '0-23/24', '9-15/3'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept wildcards' do
    ['*', '*-7', '*/7'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept comma-separated integers, ranges and step values' do
    ['0,1,2,15,23', '0-5,11-23', '0-11/2,12-23/4', '0,2-5,12-23/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept arrays of valid expressions' do
    [
      [0, 3, 6, 9, 12, 15, 18, 21],
      [0, '3', 6, '9', 12, '15', 18, '21'],
      ['0-5', '18-23'],
      ['*'],
      ['*/2', '*/5'],
      ['*/5', 3],
      ['0-5', 23],
      ['*/5', '5-7', 23],
    ].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'reject leading zeroes in integers and ranges' do
    ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0-01', '0,1,02'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject leading zeroes in step values' do
    ['*/01', '*/02', '*/03', '*/04', '*/05', '*/06', '*/07', '*/08', '*/09'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject out of range integers' do
    [-1, '-1', 24, '24', '0-24', '0-24/5', '*/0', '*/25', '-1,0,1', '22,23,24'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject incorrect values' do
    ['', [], [''], '1,', '1,2,', '*/*', 'foo'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
