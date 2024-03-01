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

      # Test the use case for systemd module
      user{ 'testu':
        ensure => present,
        uid    => 250,
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

  context 'put the uid into environment of an exec ' do
    let(:pp) do
      <<-MANIFEST
      exec{ 'env_to_file':
        user        => 'testu',
        environment => Deferred(
          'inline_epp',
          [
            'MY_XDG_RUNTIME_DIR=/run/user/<%= $pwval["uid"] %>',
            { 'pwval' => Deferred('stdlib::getpwnam',['testu'])}
          ]
        ),
        command     => 'echo $MY_XDG_RUNTIME_DIR > /tmp/test-xdg-dir',
        path        => $facts['path'],
        creates     => '/tmp/test-xdg-dir',
      }
    MANIFEST
    end

    it 'works idempotently with no errors' do
      apply_manifest(pp, catch_failures: true) unless os[:family] == 'windows'
      apply_manifest(pp, catch_changes: true) unless os[:family] == 'windows'
    end

    describe file('/tmp/test-xdg-dir') do
      it { is_expected.to contain '/run/user/250' } unless os[:family] == 'windows'
      it { is_expected.to be_owned_by 'testu' } unless os[:family] == 'windows'
    end
  end

  # This puppet fails on Puppet7
  # It fails with " Error: can't find user for testx"
  # This is
  # https://puppet.atlassian.net/browse/PUP-11526
  # Code below should be fine but the fact function is not defined
  # which I don't understand so I can't mark as pending on Puppet7.
  #  context 'put the uid into environment of an exec' do
  #  let(:pp) do
  #      <<-MANIFEST
  #     user{ 'testx':
  #       ensure => present,
  #       uid    => 251,
  #     }
  #     exec{ 'env_to_file':
  #       user        => 'testx',
  #       environment => Deferred(
  #         'inline_epp',
  #         [
  #           'MY_XDG_RUNTIME_DIR=/run/user/<%= $pwval["uid"] %>',
  #           { 'pwval' => Deferred('stdlib::getpwnam',['testx'])}
  #         ]
  #       ),
  #       command     => 'echo $MY_XDG_RUNTIME_DIR > /tmp/testx-xdg-dir',
  #       path        => $facts['path'],
  #       creates     => '/tmp/testx-xdg-dir',
  #       require     => User['testx'],
  #     }
  #   MANIFEST
  #    end
  #
  #    it 'works idempotently with no errors' do
  #      pending('puppet7 having https://puppet.atlassian.net/browse/PUP-11526') if fact('puppetversion').to_f < 8 && (os[:family] != 'windows')
  #      apply_manifest(pp, catch_failures: true) unless os[:family] == 'windows'
  #      apply_manifest(pp, catch_changes: true) unless os[:family] == 'windows'
  #    end
  #
  #    describe file('/tmp/testx-xdg-dir') do
  #      it {
  #        pending('puppet7 having https://puppet.atlassian.net/browse/PUP-11526') if fact('puppetversion').to_f < 8 && (os[:family] != 'windows')
  #        is_expected.to contain '/run/user/251' unless os[:family] == 'windows'
  #      }
  #      it {
  #        pending('puppet7 having https://puppet.atlassian.net/browse/PUP-11526') if fact('puppetversion').to_f < 8 && (os[:family] != 'windows')
  #        is_expected.to be_owned_by 'testx' unless os[:family] == 'windows'
  #      }
  #    end
end
