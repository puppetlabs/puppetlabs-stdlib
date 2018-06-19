require 'spec_helper_acceptance'

describe 'floor function', :if => Puppet::Util::Package.versioncmp(return_puppet_version, '6.0.0') < 0 do
  describe 'success' do
    pp1 = <<-DOC
      $a = 12.8
      $b = 12
      $o = floor($a)
      if $o == $b {
        notify { 'output correct': }
      }
    DOC
    it 'floors floats' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
      $a = 7
      $b = 7
      $o = floor($a)
      if $o == $b {
        notify { 'output correct': }
      }
    DOC
    it 'floors integers' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
