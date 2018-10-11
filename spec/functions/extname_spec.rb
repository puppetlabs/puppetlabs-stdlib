require 'spec_helper'

describe 'stdlib::extname' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::extname' expects 1 argument, got none}) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(ArgumentError, %r{'stdlib::extname' expects 1 argument, got 2}) }
  it { is_expected.to run.with_params([]).and_raise_error(ArgumentError, %r{'stdlib::extname' parameter 'filename' expects a String value, got Array}) }
  it { is_expected.to run.with_params('test.rb').and_return('.rb') }
  it { is_expected.to run.with_params('a/b/d/test.rb').and_return('.rb') }
  it { is_expected.to run.with_params('test').and_return('') }
  it { is_expected.to run.with_params('.profile').and_return('') }

  context 'with UTF8 and double byte characters' do
    it { is_expected.to run.with_params('file_√ạĺűē/竹.rb').and_return('.rb') }
  end
end
