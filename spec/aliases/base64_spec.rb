require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::base64', type: :class do
    describe 'valid handling' do
      %w(
        asdasdASDSADA342386832/746+=
        asdasdASDSADA34238683274/6+
        asdasdASDSADA3423868327/46+==
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
          'asdads asdasd'
        ].each do |value|
          describe value.inspect do
            let(:params) { { value: value } }
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Base64}) }
          end
        end
      end
    end
  end
end
