require 'spec_helper'

describe 'merge' do
  it { is_expected.not_to eq(nil) }
  it {
    is_expected.to run \
      .with_params({}, 'two') \
      .and_raise_error(
        ArgumentError, \
        Regexp.new(Regexp.escape("rejected: parameter 'args' expects a value of type Undef, Hash, or String[0, 0], got String")),
      )
  }
  it {
    is_expected.to run \
      .with_params({}, 1) \
      .and_raise_error(ArgumentError, %r{parameter 'args' expects a value of type Undef, Hash, or String, got Integer})
  }
  it {
    is_expected.to run \
      .with_params({ 'one' => 1, 'three' => { 'four' => 4 } }, 'two' => 'dos', 'three' => { 'five' => 5 }) \
      .and_return('one' => 1, 'three' => { 'five' => 5 }, 'two' => 'dos')
  }

  it { is_expected.to run.with_params.and_return({}) }
  it { is_expected.to run.with_params({}).and_return({}) }
  it { is_expected.to run.with_params({}, {}).and_return({}) }
  it { is_expected.to run.with_params({}, {}, {}).and_return({}) }

  describe 'should accept empty strings as puppet undef' do
    it { is_expected.to run.with_params({}, '').and_return({}) }
  end

  it { is_expected.to run.with_params({ 'key' => 'value' }, {}).and_return('key' => 'value') }
  it { is_expected.to run.with_params({}, 'key' => 'value').and_return('key' => 'value') }
  it { is_expected.to run.with_params({ 'key' => 'value1' }, 'key' => 'value2').and_return('key' => 'value2') }
  it {
    is_expected.to run \
      .with_params({ 'key1' => 'value1' }, { 'key2' => 'value2' }, 'key3' => 'value3') \
      .and_return('key1' => 'value1', 'key2' => 'value2', 'key3' => 'value3')
  }
  describe 'should accept iterable and merge produced hashes' do
    it {
      is_expected.to run \
        .with_params([1, 2, 3]) \
        .with_lambda { |_hsh, val| { val => val } } \
        .and_return(1 => 1, 2 => 2, 3 => 3)
    }
    it {
      is_expected.to run \
        .with_params([1, 2, 3]) \
        .with_lambda { |_hsh, val| { val => val } unless val == 2 } \
        .and_return(1 => 1, 3 => 3)
    }
    it {
      is_expected.to run \
        .with_params([1, 2, 3]) \
        # rubocop:disable Style/Semicolon
        .with_lambda { |_hsh, val| raise StopIteration if val == 3; { val => val } } \
        .and_return(1 => 1, 2 => 2)
    }
    it {
      is_expected.to run \
        .with_params(['a', 'b', 'b', 'c', 'b']) \
        .with_lambda { |hsh, val| { val => (hsh[val] || 0) + 1 } } \
        .and_return('a' => 1, 'b' => 3, 'c' => 1)
    }
    it {
      is_expected.to run \
        .with_params(['a', 'b', 'c']) \
        .with_lambda { |_hsh, idx, val| { idx => val } } \
        .and_return(0 => 'a', 1 => 'b', 2 => 'c')
    }
    it {
      is_expected.to run \
        .with_params('a' => 'A', 'b' => 'B', 'c' => 'C') \
        .with_lambda { |_hsh, key, val| { key => "#{key}#{val}" } } \
        .and_return('a' => 'aA', 'b' => 'bB', 'c' => 'cC')
    }
  end
end
