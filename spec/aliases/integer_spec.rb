require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'test::integer', type: :class do
    describe 'accepts integers' do
      [
        3,
        '3',
        -3,
        '-3',
        "123\nfoo",
        "foo\n123",
      ].each do |value|
        describe value.inspect do
          let(:params) { { value: value } }

          it { is_expected.to compile }
        end
      end
    end

    describe 'rejects other values' do
      ["foo\nbar", true, 'true', false, 'false', 'iAmAString', '1test', '1 test', 'test 1', 'test 1 test',
       {}, { 'key' => 'value' }, { 1 => 2 }, '', :undef, 'x', 3.7, '3.7', -3.7, '-342.2315e-12'].each do |value|
        describe value.inspect do
          let(:params) { { value: value } }

          if Puppet::Util::Package.versioncmp(Puppet.version, '5.0.0') >= 0
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a Stdlib::Compat::Integer = Variant\[Integer, Pattern\[.*\], Array\[.*\]\] value}) }
          else
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a value of type Integer, Pattern(\[.*\]+)?, or Array}) }
          end
        end
      end
    end
  end
end
