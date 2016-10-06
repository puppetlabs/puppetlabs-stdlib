require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::array', type: :class do
    describe 'accepts arrays' do
      [
        [],
        ['one'],
        [1],
        [{}],
        [[]],
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end

    describe 'rejects other values' do
      [
        '',
        'one',
        '1',
        {},
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' expects a Stdlib::Compat::Array/) }
        end
      end
    end
  end
end
