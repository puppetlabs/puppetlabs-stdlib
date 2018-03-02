require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::IP::Address::V6::Full' do
    describe 'accepts ipv6 addresses in full format' do
      [
        'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210',
        'FEDC:BA98:7654:3210:FEDC:BA98:7654:3210/60',
        '1080:0:0:0:8:800:200C:417A',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
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
