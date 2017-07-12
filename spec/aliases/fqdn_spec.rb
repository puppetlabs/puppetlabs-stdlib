require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::fqdn', type: :class do
    describe 'valid handling' do
      %w(
        example
        example.com
        www.example.com
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
          'www www.example.com'
        ].each do |value|
          describe value.inspect do
            let(:params) { { value: value } }
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Fqdn}) }
          end
        end
      end
    end
  end
end
