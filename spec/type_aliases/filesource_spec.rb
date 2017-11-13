require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Filesource' do
    describe 'valid handling' do
      %w[
        https://hello.com
        https://notcreative.org
        https://canstillaccepthttps.co.uk
        http://anhttp.com
        http://runningoutofideas.gov
        file:///hello/bla
        file:///foo/bar.log
        puppet:///modules/foo/bar.log
        puppet://pm.example.com/modules/foo/bar.log
        puppet://192.0.2.1/modules/foo/bar.log
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
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
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
          '\\var\\tmp',
          'puppet:///foo/bar.log',
          'puppet:///pm.example.com/modules/foo/bar.log',
          'puppet://bob@pm.example.com/modules/foo/bar.log',
        ].each do |value|
          describe value.inspect do
            it { is_expected.not_to allow_value(value) }
          end
        end
      end
    end
  end
end
