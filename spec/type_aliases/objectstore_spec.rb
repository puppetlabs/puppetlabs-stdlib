require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::ObjectStore' do
    describe 'accepts case-sensitive google cloud gs or amazon web services s3 uris' do
      [
        's3://bucket-name/path',
        's3://bucket/path/to/file.txt',
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
        'S3://bucket/path',
        'GS://bucket/path',
        5,
        3,
        'gs//bucket/path/to/file',
        's3//bucket/path/to/file',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
