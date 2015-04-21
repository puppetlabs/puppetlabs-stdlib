#! /usr/bin/env ruby -S rspec

require 'spec_helper'

describe 'respond_to' do
  describe 'with no arguments' do
    it { is_expected.to run.with_params().and_raise_error(ArgumentError, /Must specify a resource type/) }
  end

  describe 'when looking up a class' do
    let(:pre_condition) do
      'class mock ($mocked_var1, $mocked_var2) { }'
    end

    it { is_expected.to run.with_params('class', 'mock', 'mocked_var1').and_return(true) }
    it { is_expected.to run.with_params('class', 'mock', ['mocked_var1']).and_return(true) }
    it { is_expected.to run.with_params('class', 'mock', 'nonexistent').and_return(false) }
    it { is_expected.to run.with_params('class', 'mock', ['mocked_var1', 'mocked_var2']).and_return(true) }
    it { is_expected.to run.with_params('class', 'mock', ['mocked_var1', 'mocked_var2', 'nonexistent']).and_return(false) }

    it { is_expected.to run.with_params('class').and_raise_error(ArgumentError, /Must specify a class name/) }
  end

  describe 'when looking up a defined type' do
    let(:pre_condition) do
      'define mock ($mocked_var1, $mocked_var2) { }'
    end

    it { is_expected.to run.with_params('mock', 'mocked_var1').and_return(true) }
    it { is_expected.to run.with_params('mock', ['mocked_var1']).and_return(true) }
    it { is_expected.to run.with_params('mock', 'nonexistent').and_return(false) }
    it { is_expected.to run.with_params('mock', ['mocked_var1', 'mocked_var2']).and_return(true) }
    it { is_expected.to run.with_params('mock', ['mocked_var1', 'mocked_var2', 'nonexistent']).and_return(false) }

    it { is_expected.to run.with_params('mock').and_raise_error(ArgumentError, /Must specify parameter\(s\)/) }
  end

  describe 'when looking up a nonexistent type' do
    it { is_expected.to run.with_params('nonexistent', 'parameter').and_raise_error(ArgumentError, /The nonexistent resource could not be found/) }
  end

  describe 'when looking up a nonexistent class' do
    it { is_expected.to run.with_params('class', 'nonexistent', 'parameter').and_raise_error(ArgumentError, /The nonexistent class could not be found/) }
  end
end
