# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::has_function' do
  let(:pre_condition) { 'function puppet_func {}' }

  before(:each) do
    Puppet::Parser::Functions.newfunction(:test_3x_func) do |_args|
      true
    end
  end

  it { is_expected.not_to be_nil }

  # Itself, a namespaced function:
  it { is_expected.to run.with_params('stdlib::has_function').and_return(true) }

  # A namespaced function which does not exist:
  it { is_expected.to run.with_params('stdlib::not_a_function').and_return(false) }

  # A top-function which does not exist:
  it { is_expected.to run.with_params('not_a_function').and_return(false) }

  # A Puppet core function:
  it { is_expected.to run.with_params('assert_type').and_return(true) }

  # A Puppet function stubbed during testing:
  it { is_expected.to run.with_params('puppet_func').and_return(true) }

  # A file-loaded 3x style function in stdlib:
  it { is_expected.to run.with_params('validate_augeas').and_return(true) }

  # A stubbed 3x-style function:
  it { is_expected.to run.with_params('test_3x_func').and_return(true) }
end
