require 'spec_helper'

describe 'test::numeric', type: :class do
  describe 'accepts numerics' do
    [
      3,
      '3',
      -3,
      '-3',
      3.7,
      '3.7',
      -3.7,
      '3.7',
      '-342.2315e-12',
    ].each do |value|
      describe value.inspect do
        let(:params) {{ value: value }}
        it { is_expected.to compile }
      end
    end
  end

  describe 'rejects other values' do
    [ true, 'true', false, 'false', 'iAmAString', '1test', '1 test', 'test 1', 'test 1 test', {}, { 'key' => 'value' }, { 1=> 2 }, '', :undef , 'x' ].each do |value|
      describe value.inspect do
        let(:params) {{ value: value }}
        it { is_expected.to compile.and_raise_error(/parameter 'value' expects a value of type Numeric, Pattern(\[.*\]+)?, or Array/) }
      end
    end
  end
end
