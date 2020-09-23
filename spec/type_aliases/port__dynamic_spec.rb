require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Port::Ephemeral' do
    describe 'valid ephemeral port' do
      [
        49_152,
        51_337,
        65_000,
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'https',
          '443',
          -1,
          80,
          443,
          1023,
          1337,
          8080,
          28_080,
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
