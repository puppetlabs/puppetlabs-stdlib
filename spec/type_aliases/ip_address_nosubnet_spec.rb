require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::IP::Address::Nosubnet' do
    describe 'accepts ipv4 and ipv6 addresses without subnets' do
      [
        '224.0.0.0',
        '255.255.255.255',
        '0.0.0.0',
        '192.88.99.0',
        '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
        'fa76:8765:34ac:0823:ab76:eee9:0987:1111',
        '127.0.0.1',
        '8.8.4.4',
        '52.10.10.141',
        'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210',
        'FF01:0:0:0:0:0:0:101',
        'FF01::101',
        '::',
        '12AB::CD30:192.168.0.1',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        '10.1.240.4/24',
        'FF01:0:0:0:0:0:0:101/32',
        'FF01::101/60',
        'nope',
        '77',
        '4.4.4',
        '2001:0db8:85a3:000000:0000:8a2e:0370:7334',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
