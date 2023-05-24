# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::sha256' do
  context 'when default' do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{stdlib::sha256}) }
  end

  context 'when testing a simple string' do
    it { is_expected.to run.with_params('abc').and_return('ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad') }
    it { is_expected.to run.with_params('acb').and_return('8e9766083b3bfc2003f791c9853941b0ea035d16379bfec16b72d376e272fa57') }
    it { is_expected.to run.with_params('my string').and_return('2f7e2089add0288a309abd71ffcc3b3567e2d4215e20e6ed3b74d6042f7ef8e5') }
    it { is_expected.to run.with_params('0').and_return('5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9') }
  end

  context 'when testing a sensitive string' do
    it { is_expected.to run.with_params(sensitive('my string')).and_return('2f7e2089add0288a309abd71ffcc3b3567e2d4215e20e6ed3b74d6042f7ef8e5') }
  end

  context 'when testing an integer' do
    it { is_expected.to run.with_params(0).and_return('5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9') }
    it { is_expected.to run.with_params(100).and_return('ad57366865126e55649ecb23ae1d48887544976efea46a48eb5d85a6eeb4d306') }
    it { is_expected.to run.with_params(sensitive(100)).and_return('ad57366865126e55649ecb23ae1d48887544976efea46a48eb5d85a6eeb4d306') }
  end

  context 'when testing a float' do
    it { is_expected.to run.with_params(200.3).and_return('441adfa0dd670f4193e4b6e4e373bd7fd3861ee53c834c562b825af79bf7dc98') }

    # .0 isn't always converted into an integer, but should have rational truncation
    it { is_expected.to run.with_params(100.0).and_return('43b87f618caab482ebe4976c92bcd6ad308b48055f1c27b4c574f3e31d7683e0') }
    it { is_expected.to run.with_params(sensitive(100.0000)).and_return('43b87f618caab482ebe4976c92bcd6ad308b48055f1c27b4c574f3e31d7683e0') }
  end

  context 'when testing a bool' do
    it { is_expected.to run.with_params(true).and_return('b5bea41b6c623f7c09f1bf24dcae58ebab3c0cdd90ad966bc43a45b44867e12b') }
    it { is_expected.to run.with_params(false).and_return('fcbcf165908dd18a9e49f7ff27810176db8e9f63b4352213741664245224f8aa') }
  end

  context 'when testing a binary' do
    it { is_expected.to run.with_params("\xFE\xED\xBE\xEF").and_return('bf6b255a261ddde9ea66060dcb239e06d321ad37755d2a97a5846f5144b779b4') }
  end
end
