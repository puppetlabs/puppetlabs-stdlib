# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::Cron::Month' do
  describe 'accept integers' do
    [1, 2, 5, 10, 12].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept integers as strings' do
    ['1', '2', '5', '10', '12'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept uppercase month names' do
    ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept lowercase month names' do
    ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept ranges' do
    ['1-12', '1-6', '7-12', '7-10', 'JAN-DEC', 'JAN-JUN', 'JUN-DEC', '1-DEC', 'JAN-12'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept step values' do
    ['1-12/2', '1-12/12', '7-12/3', 'JAN-DEC/2', 'JAN-12/2', '1-DEC/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept wildcards' do
    ['*', '*-10', '*-OCT', '*/10'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept comma-separated integers, ranges and step values' do
    ['1,4,8,12', '1-5,6-10', '1-6/2,7-12/3', '1,MAR-APR,8-12/2', 'JAN,MAR-APR,AUG-DEC/2'].each do |value|
      it { is_expected.to allow_value(value) }
    end
  end
  describe 'accept arrays of valid expressions' do
    [
      [1, 3, 6, 9, 12],
      [1, '3', 6, '9', 12],
      ['1-6', '7-12'],
      ['JAN', 'mar', 'JUL'],
      ['*'],
      ['*/2', '*/4'],
      ['*/6', 6],
      ['1-12', 12],
      ['*/5', '6-9', 12],
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
    [0, '0', 13, '13', '0-12', '1-13', '0-12/5', '1-13/5', '*/0', '*/13', '0,1,2', '11,12,13'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
  describe 'reject incorrect values' do
    ['', [], [''], '1,', '1,2,', '*/*', 'foo', 'JANUARY', 'JANJAN', '1-JANJAN'].each do |value|
      it { is_expected.not_to allow_value(value) }
    end
  end
end
