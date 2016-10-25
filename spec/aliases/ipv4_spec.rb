require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::ipv4', type: :class do
    describe 'accepts ipv4 addresses' do
      SharedData::IPV4_PATTERNS.each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      SharedData::IPV4_NEGATIVE_PATTERNS.each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Compat::Ipv4/) }
        end
      end
    end
  end
end
