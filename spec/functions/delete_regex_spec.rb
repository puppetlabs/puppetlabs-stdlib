require 'spec_helper'

describe 'delete_regex' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params([], 'two') }
  it { is_expected.to run.with_params({}, 'two') }
  it { is_expected.to run.with_params([], 'two', 'three').and_raise_error(Puppet::ParseError, %r{Wrong number of arguments}) }
  it { is_expected.to run.with_params(1, 'two').and_raise_error(TypeError, %r{First argument must be an Array, Hash, or String}) }

  describe 'deleting from an array' do
    it { is_expected.to run.with_params([], '').and_return([]) }
    it { is_expected.to run.with_params([], 'two').and_return([]) }
    it { is_expected.to run.with_params(['two'], 'two').and_return([]) }
    it { is_expected.to run.with_params(['two', 'two'], 'two').and_return([]) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], '^t.*').and_return(['one']) }
    it { is_expected.to run.with_params(['ab', 'b', 'c', 'b'], 'b').and_return(['ab', 'c']) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], 'four').and_return(['one', 'two', 'three']) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], 'e').and_return(['one', 'two', 'three']) }
    it { is_expected.to run.with_params(['one', 'two', 'three'], 'two').and_return(['one', 'three']) }
    it { is_expected.to run.with_params(['two', 'one', 'two', 'three', 'two'], 'two').and_return(['one', 'three']) }
    it { is_expected.to run.with_params(['abracadabra'], 'abr').and_return(['abracadabra']) }
    it { is_expected.to run.with_params(['abracadabra'], '^.*jimbob.*$').and_return(['abracadabra']) }
  end

  describe 'deleting from an array' do
    it { is_expected.to run.with_params({}, '').and_return({}) }
    it { is_expected.to run.with_params({}, 'key').and_return({}) }
    it { is_expected.to run.with_params({ 'key' => 'value' }, 'key').and_return({}) }
    it {
      is_expected.to run \
        .with_params({ 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }, 'key2') \
        .and_return('key1' => 'value1', 'key3' => 'value3')
    }
    it {
      is_expected.to run \
        .with_params({ 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }, ['key1', 'key2']) \
        .and_return('key3' => 'value3')
    }
  end

  it 'leaves the original array intact' do
    argument1 = ['one', 'two', 'three']
    original1 = argument1.dup
    subject.execute(argument1, 'two')
    expect(argument1).to eq(original1)
  end
  it 'leaves the original hash intact' do
    argument1 = { 'key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3' }
    original1 = argument1.dup
    subject.execute(argument1, 'key2')
    expect(argument1).to eq(original1)
  end
end
