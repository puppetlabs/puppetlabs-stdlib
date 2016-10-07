require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::windowspath', type: :class do
    describe 'valid handling' do
      %w{
        C:\\
        C:\\WINDOWS\\System32
        C:/windows/system32
        X:/foo/bar
        X:\\foo\\bar
        \\\\host\\windows
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
          "/usr2/username/bin:/usr/local/bin:/usr/bin:.",
          "C;//notright/here",
          "C:noslashes"
        ].each do |value|
          describe value.inspect do
            let(:params) {{ value: value }}
            it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Windowspath/) }
          end
        end
      end

    end
  end
end
