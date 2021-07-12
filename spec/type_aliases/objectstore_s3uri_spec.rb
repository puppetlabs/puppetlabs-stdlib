# frozen_string_literal: true

require 'spec_helper'

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
      "\ns3://bucket-name/path",
      "\ns3://bucket-name/path\n",
      "s3://bucket-name/path\n",
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
