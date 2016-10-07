require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::ipv6', type: :class do
    describe 'accepts ipv6 addresses' do
      [
        '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
        'fa76:8765:34ac:0823:ab76:eee9:0987:1111'
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
        '2000:7334'
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Compat::Ipv6/) }
        end
      end
    end
  end
end
