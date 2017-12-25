require 'spec_helper'

describe 'ensure_file' do
  context 'return :file or :absent with correct parameter' do
    it { is_expected.to run.with_params(true).and_return('file') }
    it { is_expected.to run.with_params('present').and_return('file') }
    it { is_expected.to run.with_params(false).and_return('absent') }
    it { is_expected.to run.with_params('absent').and_return('absent') }
  end

  context 'raise an argument error with incorrect parameter' do
    [
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
