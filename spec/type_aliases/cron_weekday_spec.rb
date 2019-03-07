# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Cron::Weekday' do
  describe 'accept integers' do
    [0, 1, 2, 4, 6, 7].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept integers as strings' do
    ['0', '1', '2', '4', '6', '7'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept uppercase weekday names' do
    ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept lowercase weekday names' do
    ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept ranges' do
    ['0-6', '1-7', '0-3', '4-7', '3-7', 'MON-SUN', 'MON-FRI', 'SAT-SUN', '0-SAT', '1-SUN', 'MON-7'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept step values' do
    ['0-6/2', '0-6/6', '1-7/7', '3-7/3', 'MON-SUN/2', 'MON-7/2', '1-SUN/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept wildcards' do
    ['*', '*-3', '*-WED', '*/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept comma-separated integers, ranges and step values' do
    ['0,2,4,6', '1,3,5,7', '0-2,4-5', '0-3/2,4-6/2', '1,3-4,6-7/2', '1,WED-THU,SAT-SUN/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept arrays of valid expressions' do
    [
      [0, 2, 3, 6, 7],
      [0, '2', 3, '6', 7],
      ['0-2', '5-7'],
      ['*'],
      ['*/2', '*/3'],
      ['*/7', 7],
      ['0-6', 6],
      ['1-7', 7],
      ['*/5', '3-5', 7],
    ].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'reject leading zeroes in integers and ranges' do
    ['00', '01', '02', '03', '04', '05', '06', '07', '0-02', '0,1,02'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject leading zeroes in step values' do
    ['*/00', '*/01', '*/02', '*/03', '*/04', '*/05', '*/06', '*/07'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject out of range integers' do
    [-1, '-1', 8, '8', '0-8', '0-8/5', '*/-1', '*/8', '-1,0,1', '6,7,8'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject incorrect values' do
    ['', [], [''], '1,', '1,2,', '*/*', 'foo'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
