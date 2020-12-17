# frozen_string_literal: true

require 'spec_helper'

describe 'str2saltedpbkdf2' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params('Pa55w0rd', 2).and_raise_error(ArgumentError, %r{wrong number of arguments}i) }
  it { is_expected.to run.with_params(1, 'Using s0m3 s@lt', 50_000).and_raise_error(ArgumentError, %r{first argument must be a string}) }
  it { is_expected.to run.with_params('Pa55w0rd', 1, 50_000).and_raise_error(ArgumentError, %r{second argument must be a string}) }
  it { is_expected.to run.with_params('Pa55w0rd', 'U', 50_000).and_raise_error(ArgumentError, %r{second argument must be at least 8 bytes long}) }
  it { is_expected.to run.with_params('Pa55w0rd', 'Using s0m3 s@lt', '50000').and_raise_error(ArgumentError, %r{third argument must be an integer}) }
  it { is_expected.to run.with_params('Pa55w0rd', 'Using s0m3 s@lt', 1).and_raise_error(ArgumentError, %r{third argument must be between 40,000 and 70,000}) }

  context 'when running with "Pa55w0rd", "Using s0m3 s@lt",and "50000" as params' do
    # rubocop:disable Layout/LineLength
    it {
      is_expected.to run.with_params('Pa55w0rd', 'Using s0m3 s@lt', 50_000)
                        .and_return('password_hex' => '3577f79f7d2e73df1cf1eecc36da16fffcd3650126d79e797a8b227492d13de4cdd0656933b43118b7361692f755e5b3c1e0536f826d12442400f3467bcc8fb4ac2235d5648b0f1b0906d0712aecd265834319b5a42e98af2ced81597fd78d1ac916f6eff6122c3577bb120a9f534e2a5c9a58c7d1209e3914c967c6a467b594',
                                    'salt_hex'     => '5573696e672073306d332073406c74',
                                    'iterations'   => 50_000)
    }
    # rubocop:enable Layout/LineLength
  end
end
