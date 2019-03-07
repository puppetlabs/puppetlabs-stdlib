# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Cron::Minute' do
  describe 'accept integers' do
    [0, 1, 2, 15, 27, 34, 59].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept integers as strings' do
    ['0', '1', '2', '15', '27', '34', '59'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept ranges' do
    ['0-59', '0-15', '30-59', '45-55'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept step values' do
    ['0-59/2', '0-59/60', '30-59/3'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept wildcards' do
    ['*', '*-15', '*/15'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept comma-separated integers, ranges and step values' do
    ['0,5,10,15', '0-5,15-59', '0-29/2,30-59/3', '0,5-10,30-59/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept arrays of valid expressions' do
    [
      [0, 12, 24, 36, 48],
      [0, '12', 24, '36', 48],
      ['0-25', '30-59'],
      ['*'],
      ['*/2', '*/5'],
      ['*/5', 7],
      ['0-30', 59],
      ['*/5', '6-9', 59],
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
    [-1, '-1', 60, '60', '0-60', '0-60/5', '*/0', '*/61', '-1,0,1', '58,59,60'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject incorrect values' do
    ['', [], [''], '1,', '1,2,', '*/*', 'foo'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
