require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::ipv4', type: :class do
    describe 'accepts ipv4 addresses' do
      [
        '224.0.0.0',
        '255.255.255.255',
        '0.0.0.0',
        '192.88.99.0'
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        'nope',
        '77',
        '4.4.4',
        '2001:0db8:85a3:0000:0000:8a2e:0370:73342001:0db8:85a3:0000:0000:8a2e:0370:7334'
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Compat::Ipv4/) }
        end
      end
    end
  end
end
