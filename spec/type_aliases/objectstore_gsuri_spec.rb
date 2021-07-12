# frozen_string_literal: true

require 'spec_helper'

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
      "\ngs://mybucket/myfile.csv",
      "\ngs://mybucket/myfile.csv\n",
      "gs://mybucket/myfile.csv\n",
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
