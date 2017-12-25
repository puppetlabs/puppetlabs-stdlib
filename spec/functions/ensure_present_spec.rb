require 'spec_helper'

describe 'ensure_present' do
  context 'return :present or :absent when passed a Boolean' do
    it { is_expected.to run.with_params(true).and_return('present') }
    it { is_expected.to run.with_params(false).and_return('absent') }
  end

  context 'raise an argument error with incorrect parameter' do
    [
      :present,
      :absent,
      '',
      ' ',
      'someweirdstuff',
      'true',
      'false',
      {},
      [],
      [''],
      [' '],
    ].each do |ensure_param|
      it { is_expected.to run.with_params(ensure_param).and_raise_error(ArgumentError) }
    end
  end
end
