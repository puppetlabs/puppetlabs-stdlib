require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::base32', type: :class do
    describe 'valid handling' do
      %w(
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
      ).each do |value|
        describe value.inspect do
          let(:params) { { value: value } }
          it { is_expected.to compile }
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
          'asdasddasd9'
        ].each do |value|
          describe value.inspect do
            let(:params) { { value: value } }
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Base32}) }
          end
        end
      end
    end
  end
end
