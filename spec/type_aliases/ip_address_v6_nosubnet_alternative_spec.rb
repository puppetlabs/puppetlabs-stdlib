require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::IP::Address::V6::Nosubnet::Alternative' do
    describe 'accepts ipv6 addresses in alternative format without subnets' do
      [
        '0:0:0:0:0:0:13.1.68.3',
        '0:0:0:0:0:FFFF:129.144.52.38',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        '0:0:0:0:0:FFFF:129.144.52.38/60',
        'nope',
        '127.0.0.1',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
