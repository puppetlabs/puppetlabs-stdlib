require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::unixpath', type: :class do
    describe 'valid handling' do
      %w{
        /usr2/username/bin:/usr/local/bin:/usr/bin:.
        /var/tmp
        /Users/helencampbell/workspace/puppetlabs-stdlib
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
        ].each do |value|
          describe value.inspect do
            let(:params) {{ value: value }}
            it { is_expected.to compile.and_raise_error(/parameter 'value' expects a match for Stdlib::Unixpath/) }
          end
        end
      end

    end
  end
end
