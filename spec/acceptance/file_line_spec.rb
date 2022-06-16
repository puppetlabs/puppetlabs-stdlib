# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'file_line type' do
  let(:test_file) { (os[:family] == 'windows') ? 'C:\test\file_line_test.txt' : '/tmp/test/testfile_line_test.txt' }

  before(:all) do
    apply_manifest(<<-MANIFEST)
      case($facts['os']['family']) {
        windows: { file { 'C:\\test': ensure => directory } }
        default: { file { '/tmp/test': ensure => directory } }
      }
    MANIFEST
  end

  before(:each) do
    pp_test_file = <<-MANIFEST
      file { '#{test_file}':
        ensure  => present,
        content => 'a wild test file has appeared!',
      }
      file { '#{test_file}.does_not_exist':
        ensure => absent,
      }
    MANIFEST
    apply_manifest(pp_test_file)
  end

  context 'ensure line' do
    let(:pp) do
      <<-MANIFEST
        file_line { 'test_ensure':
          path => '#{test_file}',
          line => 'test file uses attack!',
        }
      MANIFEST
    end

    it 'applies manifest, adds line' do
      idempotent_apply(pp)
      expect(file(test_file)).to be_file
      expect(file(test_file).content).to match(%r{test file uses attack!})
    end
  end

  context 'matches and replaces line' do
    let(:pp) do
      <<-MANIFEST
        file_line { 'test_match':
          path  => '#{test_file}',
          line  => 'a tame test file has appeared!',
          match => '^a wild',
        }
      MANIFEST
    end

    it 'applies manifest, replaces line' do
      idempotent_apply(pp)
      expect(file(test_file)).to be_file
      expect(file(test_file).content).to match(%r{a tame test file has appeared!})
    end
  end

  context 'remove line' do
    context 'using match' do
      let(:pp) do
        <<-MANIFEST
          file_line { 'test_absent_match':
            ensure            => absent,
            path              => '#{test_file}',
            match             => '^a wild',
            match_for_absence => true,
          }
        MANIFEST
      end

      it 'applies manifest, removes line' do
        idempotent_apply(pp)
        expect(file(test_file)).to be_file
        expect(file(test_file).content).to be_empty
      end
    end

    context 'using line' do
      let(:pp) do
        <<-MANIFEST
          file_line { 'test_absent_line':
            ensure => absent,
            path   => '#{test_file}',
            line   => 'a wild test file has appeared!',
          }
        MANIFEST
      end

      it 'applies manifest, removes line' do
        idempotent_apply(pp)
        expect(file(test_file)).to be_file
        expect(file(test_file).content).to be_empty
      end
    end
  end

  context 'when file does not exist' do
    context 'with ensure => present' do
      let(:pp) do
        <<~MANIFEST
          file_line { 'test_absent_file':
            ensure => present,
            path   => '#{test_file}.does_not_exist',
            line   => 'this file does not exist',
          }
        MANIFEST
      end

      it 'fails to apply manifest' do
        apply_manifest(pp, expect_failures: true)
      end
    end

    context 'with ensure => present and noop => true' do
      let(:pp) do
        <<~MANIFEST
          file_line { 'test_absent_file':
            ensure => present,
            path   => '#{test_file}.does_not_exist',
            line   => 'this file does not exist',
            noop   => true,
          }
        MANIFEST
      end

      it 'would apply manifest' do
        apply_manifest(pp, catch_failures: true)
      end
    end

    context 'with ensure => present, in noop mode' do
      let(:pp) do
        <<~MANIFEST
          file_line { 'test_absent_file':
            ensure => present,
            path   => '#{test_file}.does_not_exist',
            line   => 'this file does not exist',
          }
        MANIFEST
      end

      it 'would apply manifest' do
        apply_manifest(pp, catch_failures: true, noop: true)
      end
    end
  end
end
