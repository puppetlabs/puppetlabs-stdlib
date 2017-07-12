require 'spec_helper'

if Puppet.version.to_f >= 4.5
  describe 'test::puppetsource', type: :class do
    describe 'valid handling' do
      %w(
        https://hello.com
        https://notcreative.org
        https://canstillaccepthttps.co.uk
        http://anhttp.com
        http://runningoutofideas.gov
        file:///hello/bla
        file:///foo/bar.log
        /usr2/username/bin:/usr/local/bin:/usr/bin:.
        C:/
        C:\\
        C:\\WINDOWS\\System32
        C:/windows/system32
        X:/foo/bar
        X:\\foo\\bar
        \\\\host\\windows
        //host/windows
        /var/tmp
        /var/opt/../lib/puppet
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
          nil,
          [nil],
          [nil, nil],
          { 'foo' => 'bar' },
          {},
          '',
          '*/Users//nope',
          '\\Users/hc/wksp/stdlib',
          'C:noslashes',
          '\\var\\tmp'
        ].each do |value|
          describe value.inspect do
            let(:params) { { value: value } }
            it { is_expected.to compile.and_raise_error(%r{parameter 'value' expects a match for Stdlib::Puppetsource}) }
          end
        end
      end
    end
  end
end
