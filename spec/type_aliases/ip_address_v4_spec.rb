require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::IP::Address::V4' do
    describe 'accepts ipv4 addresses' do
      [
        '127.0.0.1',
        '8.8.4.4',
        '10.1.240.4/24',
        '52.10.10.141',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        '192.168.1',
        'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210',
        '12AB::CD30:192.168.0.1',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
