require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::Ensure::PackageVersion' do
    describe 'accepts package ensure keywords and strings' do
      [
        'present',
        'absent',
        'held',
        'v20.5.2',
        '2',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end
  end
end
