# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::bounce' do
  it { is_expected.to run.with_params(2).and_return(2) }
  it { is_expected.to run.with_params('test_string').and_return('test_string') }
  it { is_expected.to run.with_params(nil).and_return(nil) }
  it { is_expected.to run.with_params([1, 2, 3, 'str']).and_return([1, 2, 3, 'str']) }
end
