# coding: utf-8
# frozen_string_literal: true

require 'spec_helper'
require 'test_data'

valid = X509_data::CERTIFICATE

describe 'Stdlib::X509::Pem::Certificate' do
  describe 'valid types' do
    [valid].flatten.each do |value|
      describe value.inspect do
        it { is_expected.to allow_value(value) }
      end
    end
  end
end
