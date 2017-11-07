require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'test::filemode', type: :class do
    describe 'valid modes' do
      %w[
        0644
        1644
        2644
        4644
        0123
        0777
      ].each do |value|
        describe value.inspect do
          let(:params) { { value: value } }

          it { is_expected.to compile }
        end
      end
    end

    describe 'invalid modes' do
      context 'garbage inputs' do
        [
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'ネット',
          '644',
          '7777',
          '1',
          '22',
          '333',
          '55555',
          '0x123',
          '0649',
        ].each do |value|
          describe value.inspect do
            let(:params) { { value: value } }

            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Filemode}) }
          end
        end
      end
    end
  end
end
