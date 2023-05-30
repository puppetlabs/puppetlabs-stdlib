# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::parsehocon' do
  it { is_expected.to run.with_params('').and_return({}) }
  it { is_expected.to run.with_params('valid hocon: string').and_return('valid hocon' => 'string') }
  it { is_expected.to run.with_params('invalid').and_raise_error(Hocon::ConfigError::ConfigParseError) }
  it { is_expected.to run.with_params('invalid', 'default').and_return('default') }
end
