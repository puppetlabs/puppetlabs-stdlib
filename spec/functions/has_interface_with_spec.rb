# frozen_string_literal: true

require 'spec_helper'

describe 'has_interface_with' do
  it { is_expected.not_to be_nil }
  it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects between 1 and 2 arguments, got none}) }
  it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(ArgumentError, %r{expects between 1 and 2 arguments, got 3}) }

  # We need to mock out the Facts so we can specify how we expect this function
  # to behave on different platforms.
  context 'when on Mac OS X Systems' do
    let(:facts) do
      {
        'networking' => {
          'interfaces' => {
            'lo0' => {
              'bindings' => [
                {
                  'address' => '127.0.0.1',
                  'netmask' => '255.0.0.0',
                  'network' => '127.0.0.0'
                },
              ],
              bindings6: [
                {
                  'address' => '::1',
                  'netmask' => 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff',
                  'network' => '::1'
                },
                {
                  'address' => 'fe80::1',
                  'netmask' => 'ffff:ffff:ffff:ffff::',
                  'network' => 'fe80::'
                },
              ],
              'ip' => '127.0.0.1',
              'ip6' => '::1',
              'mtu' => 16_384,
              'netmask' => '255.0.0.0',
              'netmask6' => 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff',
              'network' => '127.0.0.0',
              'network6' => '::1',
              'scope6' => 'host'
            }
          }
        }
      }
    end

    it { is_expected.to run.with_params('lo0').and_return(true) }
    it { is_expected.to run.with_params('lo').and_return(false) }
  end

  context 'when on Linux Systems' do
    let(:facts) do
      {
        'networking' => {
          'interfaces' => {
            'eth0' => {
              'bindings' => [
                {
                  'address' => '10.0.2.15',
                  'netmask' => '255.255.255.0',
                  'network' => '10.0.2.0'
                },
              ],
              'bindings6' => [
                {
                  'address' => 'fe80::5054:ff:fe8a:fee6',
                  'netmask' => 'ffff:ffff:ffff:ffff::',
                  'network' => 'fe80::'
                },
              ],
              'dhcp' => '10.0.2.2',
              'ip' => '10.0.2.15',
              'ip6' => 'fe80::5054:ff:fe8a:fee6',
              'mac' => '52:54:00:8a:fe:e6',
              'mtu' => 1500,
              'netmask' => '255.255.255.0',
              'netmask6' => 'ffff:ffff:ffff:ffff::',
              'network' => '10.0.2.0',
              'network6' => 'fe80::'
            },
            'eth1' => {
              'bindings' => [
                {
                  'address' => '10.0.0.2',
                  'netmask' => '255.255.255.0',
                  'network' => '10.0.0.0'
                },
              ],
              'bindings6' => [
                {
                  'address' => 'fe80::a00:27ff:fed1:d28c',
                  'netmask' => 'ffff:ffff:ffff:ffff::',
                  'network' => 'fe80::'
                },
              ],
              'ip' => '10.0.0.2',
              'ip6' => 'fe80::a00:27ff:fed1:d28c',
              'mac' => '08:00:27:d1:d2:8c',
              'mtu' => 1500,
              'netmask' => '255.255.255.0',
              'netmask6' => 'ffff:ffff:ffff:ffff::',
              'network' => '10.0.0.0',
              'network6' => 'fe80::'
            },
            'lo' => {
              'bindings' => [
                {
                  'address' => '127.0.0.1',
                  'netmask' => '255.0.0.0',
                  'network' => '127.0.0.0'
                },
              ],
              'bindings6' => [
                {
                  'address' => '::1',
                  'netmask' => 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff',
                  'network' => '::1'
                },
              ],
              'ip' => '127.0.0.1',
              'ip6' => '::1',
              'mtu' => 65_536,
              'netmask' => '255.0.0.0',
              'netmask6' => 'ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff',
              'network' => '127.0.0.0',
              'network6' => '::1'
            }
          }
        }
      }
    end

    it { is_expected.to run.with_params('lo').and_return(true) }
    it { is_expected.to run.with_params('lo0').and_return(false) }
    it { is_expected.to run.with_params('ipaddress', '127.0.0.1').and_return(true) }
    it { is_expected.to run.with_params('ipaddress', '10.0.0.2').and_return(true) }
    it { is_expected.to run.with_params('ipaddress', '8.8.8.8').and_return(false) }
    it { is_expected.to run.with_params('netmask', '255.255.255.0').and_return(true) }
    it { is_expected.to run.with_params('macaddress', '52:54:00:8a:fe:e6').and_return(true) }
    it { is_expected.to run.with_params('network', '42.0.0.0').and_return(false) }
    it { is_expected.to run.with_params('network', '10.0.0.0').and_return(true) }
  end
end
