# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::str2resource_attrib' do
  context 'when default' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{stdlib::str2resource_attrib}) }
  end

  context 'when testing simple resource definitions' do
    it { is_expected.to run.with_params('File[foo]').and_return({ 'type' => 'File', 'title' => 'foo' }) }
    it { is_expected.to run.with_params('User[foo]').and_return({ 'type' => 'User', 'title' => 'foo' }) }
  end

  context 'when someone tries a compound definition' do
    it { is_expected.to run.with_params('User[foo, bar]').and_return({ 'type' => 'User', 'title' => 'foo, bar' }) }
  end
end
