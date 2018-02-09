require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Port' do
    describe 'valid ports' do
      [
        80,
        443,
        1337,
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
          65_536,
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
