# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'stdlib::deferable_epp function' do
  let(:testfile) { (os[:family] == 'windows') ? 'C:\\test.epp' : '/tmp/test.epp' }

  before(:all) do
    apply_manifest(<<-MANIFEST)
      $_epp = @(EPP)
      <%- |
      Stdlib::Port $port,
      String[1] $password,
      | -%>
      port=<%= $port %>
      password=<%= $password %>"
      | EPP
      $_testfile = $facts['os']['family'] ? {
        'windows' => 'C:\\test.epp',
        default => '/tmp/test.epp',
      }

      file{ $_testfile:
        ensure  => file,
        content => $_epp,
      }
    MANIFEST
  end

  before(:each) do
    rm_testfile = <<-MANIFEST
      $_testfile = $facts['os']['family'] ? {
        'windows' => 'C:\\test.epp',
        default => '/tmp/test.epp',
      }
      file { "${_testfile}.rendered":
        ensure  => absent,
      }
    MANIFEST
    apply_manifest(rm_testfile)
  end

  context 'with no deferred values' do
    let(:pp) do
      <<-MANIFEST
        $_testfile = $facts['os']['family'] ? {
          'windows' => 'C:\\test.epp',
          default => '/tmp/test.epp',
        }

        file{ "${_testfile}.rendered":
          ensure  => file,
          content => stdlib::deferrable_epp(
            $_testfile,
            {'port' => 1234, 'password' => 'top_secret'}
          ),
        }
      MANIFEST
    end

    it 'applies manifest, generates file' do
      idempotent_apply(pp)
      expect(file("#{testfile}.rendered")).to be_file
      expect(file("#{testfile}.rendered").content).to match(%r{port=1234})
      expect(file("#{testfile}.rendered").content).to match(%r{password=top_secret})
    end
  end

  context 'with deferred values' do
    let(:pp) do
      <<-MANIFEST
        $_testfile = $facts['os']['family'] ? {
          'windows' => 'C:\\test.epp',
          default => '/tmp/test.epp',
        }

        file{ "${_testfile}.rendered":
          ensure  => file,
          content => stdlib::deferrable_epp(
            $_testfile,
            {'port' => 1234, 'password' => Deferred('inline_epp',['<%= $secret_password %>',{'secret_password' => 'so_secret'}])},
          ),
        }
      MANIFEST
    end

    it 'applies manifest, generates file' do
      idempotent_apply(pp)
      expect(file("#{testfile}.rendered")).to be_file
      expect(file("#{testfile}.rendered").content).to match(%r{port=1234})
      expect(file("#{testfile}.rendered").content).to match(%r{password=so_secret})
    end
  end
end
