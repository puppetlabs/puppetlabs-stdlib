require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::ObjectStore::GSUri' do
    describe 'accepts case-sensitive google cloud gs uris' do
      [
        'gs://mybucket/myfile.csv',
        'gs://bucket/path/to/file.tar.gz',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        '',
        'GS://mybucket/myfile.csv',
        5,
        'gs//mybucket/myfile.csv',
        'gs:/mybucket/myfile.csv',
        'gs:mybucket/myfile.csv',
        'gs-mybucket/myfile.csv',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
