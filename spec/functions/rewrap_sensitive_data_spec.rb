# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::rewrap_sensitive_data' do
  it { is_expected.not_to be_nil }

  context 'when called with data containing no sensitive elements' do
    it { is_expected.to run.with_params({}).and_return({}) }
    it { is_expected.to run.with_params([]).and_return([]) }
    it { is_expected.to run.with_params('a_string').and_return('a_string') }
    it { is_expected.to run.with_params(42).and_return(42) }
    it { is_expected.to run.with_params(true).and_return(true) }
    it { is_expected.to run.with_params(false).and_return(false) }

    it { is_expected.to run.with_params({ 'foo' => 'bar' }).and_return({ 'foo' => 'bar' }) }
  end

  context 'when called with a hash containing a sensitive string' do
    it 'unwraps the sensitive string and returns a sensitive hash' do
      is_expected.to run.with_params(
        {
          'username' => 'my_user',
          'password' => sensitive('hunter2')
        },
      ).and_return(sensitive(
        {
          'username' => 'my_user',
          'password' => 'hunter2'
        },
      ))
    end
  end

  context 'when called with data containing lots of sensitive elements (including nested in arrays, and sensitive hashes etc)' do
    it 'recursively unwraps everything and marks the whole result as sensitive' do
      is_expected.to run.with_params(
        {
          'a' => sensitive('bar'),
          'b' => [
            1,
            2,
            :undef,
            true,
            false,
            {
              'password'      => sensitive('secret'),
              'weird_example' => sensitive({ 'foo' => sensitive(42) }) # A sensitive hash containing a sensitive Int as the value to a hash contained in an array which is the value of a hash key...
            },
          ],
          'c' => :undef,
          'd' => [],
          'e' => true,
          'f' => false,
        },
      ).and_return(sensitive(
        {
          'a' => 'bar',
          'b' => [
            1,
            2,
            :undef,
            true,
            false,
            {
              'password'      => 'secret',
              'weird_example' => { 'foo' => 42 }
            },
          ],
          'c' => :undef,
          'd' => [],
          'e' => true,
          'f' => false,
        },
      ))
    end
  end

  context 'when a hash _key_ is sensitive' do
    it 'unwraps the key' do
      is_expected.to run.with_params(
        {
          sensitive('key') => 'value',
        },
      ).and_return(sensitive(
        {
          'key' => 'value',
        },
      ))
    end
  end

  context 'when called with a block' do
    context 'that upcases hash values' do
      it do
        is_expected.to run
          .with_params({ 'secret' => sensitive('hunter2') })
          .with_lambda { |data| data.transform_values { |value| value.upcase } }
          .and_return(sensitive({ 'secret' => 'HUNTER2' }))
      end
    end
    context 'that converts data to yaml' do
      it do
        is_expected.to run
          .with_params({ 'secret' => sensitive('hunter2') })
          .with_lambda { |data| data.to_yaml }
          .and_return(sensitive("---\nsecret: hunter2\n"))
      end
    end
  end
end
