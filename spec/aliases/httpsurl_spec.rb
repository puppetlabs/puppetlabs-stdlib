require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::httpsurl', type: :class do
    describe 'valid handling' do
      %w{
        https://hello.com
        https://notcreative.org
        https://notexciting.co.uk
      }.each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end

    describe 'invalid path handling' do
      context 'garbage inputs' do
        [
          nil,
          [ nil ],
          [ nil, nil ],
          { 'foo' => 'bar' },
          { },
          '',
          "httds://notquiteright.org",
          "hptts:/nah",
          "https;//notrightbutclose.org"
        ].each do |value|
          describe value.inspect do
            let(:params) {{ value: value }}
            it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::HTTPSUrl/) }
          end
        end
      end

    end
  end
end
