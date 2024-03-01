# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'function stdlib::getpwnam' do
  context 'finding the UID of the root user' do
    let(:pp) do
      <<-MANIFEST
      $_password_entry = stdlib::getpwnam('root')
      file{ '/tmp/roots_uid.txt':
        ensure  => file,
        content => "${_password_entry['uid']}\n",
      }
    MANIFEST
    end

    it 'works idempotently with no errors' do
      apply_manifest(pp, catch_failures: true) unless os[:family] == 'windows'
      apply_manifest(pp, catch_changes: true) unless os[:family] == 'windows'
    end

    describe file('/tmp/roots_uid.txt') do
      it { is_expected.to contain '0' } unless os[:family] == 'windows'
    end
  end
end
