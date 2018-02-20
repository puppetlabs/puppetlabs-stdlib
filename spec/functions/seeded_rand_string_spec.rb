require 'spec_helper'

describe 'seeded_rand_string' do
  it { is_expected.not_to be(nil) }

  # Test for erroneous params
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects between.+got none}i) }
  it { is_expected.to run.with_params(1).and_raise_error(ArgumentError, %r{expects between.+got 1}i) }
  it { is_expected.to run.with_params('1', 'hello').and_raise_error(ArgumentError, %r{parameter 'length' expects an Integer value}i) }
  it { is_expected.to run.with_params(1, 1).and_raise_error(ArgumentError, %r{parameter 'seed' expects a String value}i) }
  it { is_expected.to run.with_params(1, 'hello', 1).and_raise_error(ArgumentError, %r{parameter 'charset' expects a.+String}i) }

  # Test regular run
  it { is_expected.to run.with_params(100, 'hello') }

  # Test custom charsets
  it { is_expected.to run.with_params(100, 'hello', 'abcd').and_return(%r{[a-d]{100}}) }
  it { is_expected.to run.with_params(100, 'hello', 'abcdefgh').and_return(%r{[a-h]{100}}) }
  it { is_expected.to run.with_params(100, 'hello', 'ab,|').and_return(%r{[ab,|]{100}}) }

  # Test behavior
  it 'generates the same string with the same seed' do
    rand_str_one = call_function(:seeded_rand_string, 300, 'my_seed')
    rand_str_two = call_function(:seeded_rand_string, 300, 'my_seed')

    expect(rand_str_one).to eq(rand_str_two)
  end
  it 'generates different strings if seeded differently' do
    rand_str_one = call_function(:seeded_rand_string, 300, 'my_seed_one')
    rand_str_two = call_function(:seeded_rand_string, 300, 'my_seed_two')

    expect(rand_str_one).not_to eq(rand_str_two)
  end
end
