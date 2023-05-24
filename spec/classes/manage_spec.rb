# frozen_string_literal: true

require 'spec_helper'

describe 'stdlib::manage' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end

  describe 'with resources to create' do
    let :pre_condition do
      <<-PRECOND
        file { '/etc/motd.d' : }
        service { 'sshd' : }
      PRECOND
    end
    let :params do
      {
        'create_resources' => {
          'file' => {
            '/etc/motd.d/hello' => {
              'content' => 'I say Hi',
              'notify' => 'Service[sshd]'
            }
          },
          'package' => {
            'example' => {
              'ensure' => 'installed',
              'subscribe' => ['Service[sshd]', 'File[/etc/motd.d]']
            }
          }
        }
      }
    end

    it { is_expected.to compile }
    it { is_expected.to contain_file('/etc/motd.d/hello').with_content('I say Hi').with_notify('Service[sshd]') }
    it { is_expected.to contain_package('example').with_ensure('installed').that_subscribes_to(['Service[sshd]', 'File[/etc/motd.d]']) }
  end
end
