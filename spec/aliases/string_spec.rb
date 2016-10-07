require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::string', type: :class do
    describe 'accepts strings' do
      [
        '',
        'one',
        nil,
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end

    describe 'rejects other values' do
      [
        [],
        {},
        1,
        true,
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a String/) }
        end
      end
    end
  end
end
