require 'spec_helper'

describe 'stdlib::concat' do
  # without knowing details about the implementation, this is the only test
  # case that we can autogenerate. You should add more examples below!
  it { is_expected.not_to eq(nil) }

  #################################
  # Below are some example test cases. You may uncomment and modify them to match
  # your needs. Notice that they all expect the base error class of `StandardError`.
  # This is because the autogenerated function uses an untyped array for parameters
  # and relies on your implementation to do the validation. As you convert your
  # function to proper dispatches and typed signatures, you should change the
  # expected error of the argument validation examples to `ArgumentError`.
  #
  # Other error types you might encounter include
  #
  # * StandardError
  # * ArgumentError
  # * Puppet::ParseError
  #
  # Read more about writing function unit tests at https://rspec-puppet.com/documentation/functions/
  #
  #   it 'raises an error if called with no argument' do
  #     is_expected.to run.with_params.and_raise_error(StandardError)
  #   end
  #
  #   it 'raises an error if there is more than 1 arguments' do
  #     is_expected.to run.with_params({ 'foo' => 1 }, 'bar' => 2).and_raise_error(StandardError)
  #   end
  #
  #   it 'raises an error if argument is not the proper type' do
  #     is_expected.to run.with_params('foo').and_raise_error(StandardError)
  #   end
  #
  #   it 'returns the proper output' do
  #     is_expected.to run.with_params(123).and_return('the expected output')
  #   end
  #################################
end
