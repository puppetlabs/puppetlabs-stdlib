require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Base32' do
    describe 'valid handling' do
      %w[
        ASDASDDASD3453453
        ASDASDDASD3453453=
        ASDASDDASD3453453==
        ASDASDDASD3453453===
        ASDASDDASD3453453====
        ASDASDDASD3453453=====
        ASDASDDASD3453453======
        asdasddasd3453453
        asdasddasd3453453=
        asdasddasd3453453==
        asdasddasd3453453===
        asdasddasd3453453====
        asdasddasd3453453=====
        asdasddasd3453453======
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          'asdasd!@#$',
          '=asdasd9879876876+/',
          'asda=sd9879876876+/',
          'asdaxsd9879876876+/===',
          'asdads asdasd',
          'asdasddasd3453453=======',
          'asdaSddasd',
          'asdasddasd1',
          'asdasddasd9',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
