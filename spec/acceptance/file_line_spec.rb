require 'spec_helper_acceptance'

test_file = (os[:family] == 'windows') ? 'C:\Users\Administrator\file_line_test.txt' : '/tmp/file_line_test.txt'

describe 'file_line type' do
  before(:each) do
    pp_test_file = <<-MANIFEST
      file { '#{test_file}':
        ensure  => present,
        content => 'a wild test file has appeared!',
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
end
