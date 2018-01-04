require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::IP::Address::V6::Nosubnet::Compressed' do
    describe 'accepts ipv6 addresses in compressed format without subnets' do
      [
        '1080::8:800:200C:417A',
        'FF01::101',
        '::1',
        '::',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        '1080::8:800:200C:417A/60',
        'nope',
        '127.0.0.1',
        'FEDC::BA98:7654:3210::3210',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
