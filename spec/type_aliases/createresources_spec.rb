# frozen_string_literal: true

require 'spec_helper'

describe 'Stdlib::CreateResources' do
  it { is_expected.to allow_value({ 'name' => { 'ensure' => 'present', 'key' => 1 } }) }
end
