# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::str2resource' do
  context 'when default' do
    it { is_expected.not_to be_nil }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{stdlib::str2resource}) }
  end

  context 'when testing simple resource definitions exist' do
    let :pre_condition do
      <<-PRECOND
        file { 'foo': }
        file { '/foo': }
        file { 'foot': }
        user { 'foo': }
      PRECOND
    end

    file_foo = Puppet::Resource.new(:file, 'foo')
    user_foo = Puppet::Resource.new(:user, 'foo')

    it { is_expected.to run.with_params('File[foo]').and_return(file_foo) }
    it { is_expected.not_to run.with_params('File[\'foo\']') }
    it { is_expected.not_to run.with_params('File["foo"]') }

    it { is_expected.to run.with_params('User[foo]').and_return(user_foo) }
  end

  context 'when someone tries a compound definition' do
    let :pre_condition do
      'user { "foo, bar": }'
    end

    user_foo_bar = Puppet::Resource.new(:user, 'foo, bar')

    it { is_expected.to run.with_params('User[foo, bar]').and_return(user_foo_bar) }
  end

  context 'when testing simple resource definitions no exist' do
    it { is_expected.not_to run.with_params('File[foo]') }
  end
end
