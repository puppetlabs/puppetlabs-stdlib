# frozen_string_literal: true

require 'spec_helper'

describe 'has_ip_network' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{'stdlib::has_ip_network' expects 1 argument, got none}) }
  it { is_expected.to run.with_params('one', 'two').and_raise_error(ArgumentError, %r{'stdlib::has_ip_network' expects 1 argument, got 2}) }

  context 'when on Linux Systems' do
    let(:facts) do
      {
        networking: {
          'interfaces' => {
            'eth0' => {
              'network' => '10.0.0.0',
            },
            'lo' => {
              'network' => '127.0.0.0',
            },
          },
        },
      }
    end

    it { is_expected.to run.with_params('127.0.0.0').and_return(true) }
    it { is_expected.to run.with_params('10.0.0.0').and_return(true) }
    it { is_expected.to run.with_params('8.8.8.0').and_return(false) }
    it { is_expected.to run.with_params('invalid').and_raise_error(ArgumentError, %r{parameter 'ip_network' expects a match}) }
  end
end
