require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::host', type: :class do
    describe 'valid handling' do
      %w(
        example
        example.com
        www.example.com
        2001:0db8:85a3:0000:0000:8a2e:0370:7334
        fa76:8765:34ac:0823:ab76:eee9:0987:1111
        2001:0db8::1
        224.0.0.0
        255.255.255.255
        0.0.0.0
        192.88.99.0
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
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Host}) }
          end
        end
      end
    end
  end
end
