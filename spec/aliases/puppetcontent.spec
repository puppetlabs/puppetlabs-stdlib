require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::puppetcontent', type: :class do
    describe 'valid handling' do
      %w{
        usr2/username/bin
        var/tmp
        var///tmp
        tea/file.erb
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
          "C:/whatever",
          "\\var\\tmp",
          "\\Users/hc/wksp/stdlib",
          "*/Users//nope"
          "/Users//nope"
          "/Users/nope"
        ].each do |value|
          describe value.inspect do
            let(:params) {{ value: value }}
            it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Puppetcontent/) }
          end
        end
      end

    end
  end
end
