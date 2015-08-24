require 'spec_helper'

describe 'parseyaml' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params().and_raise_error(ArgumentError, /wrong number of arguments/i) }
  it { is_expected.to run.with_params('["one", "two", "three"]').and_return(['one', 'two', 'three']) }
  it { is_expected.to run.with_params('', 'default_value').and_return('default_value') }
  it { is_expected.to run.with_params('', { 'a' => '1' }).and_return({ 'a' => '1' }) }
  it { is_expected.to run.with_params("---\na: '1'\n").and_return({ 'a' => '1' }) }
  it { is_expected.to run.with_params("---\na: '1'\n", 'default_value').and_return({ 'a' => '1' }) }
  context 'when running on modern rubies', :unless => RUBY_VERSION == '1.8.7' do
    it { is_expected.to run.with_params('["one"').and_raise_error(Psych::SyntaxError) }
  end
  context 'when running on ruby 1.8.7, which does not have Psych', :if => RUBY_VERSION == '1.8.7' do
    it { is_expected.to run.with_params('["one"').and_raise_error(ArgumentError) }
  end
end
