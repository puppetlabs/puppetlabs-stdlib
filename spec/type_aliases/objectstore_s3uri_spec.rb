require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.5.0') >= 0
  describe 'Stdlib::ObjectStore::S3Uri' do
    describe 'accepts case-sensitive amazon web services s3 uris' do
      [
        's3://bucket-name/path',
        's3://bucket/path/to/file.txt',
      ].each do |value|
        describe value.inspect do
          it { is_expected.to allow_value(value) }
        end
      end
    end

    describe 'rejects other values' do
      [
        '',
        'S3://bucket-name/path',
        3,
        's3:/bucket-name/path',
        's3//bucket-name/path',
        's3:bucket-name/path',
        's3-bucket-name/path',
      ].each do |value|
        describe value.inspect do
          it { is_expected.not_to allow_value(value) }
        end
      end
    end
  end
end
