require 'spec_helper_acceptance'

describe 'ceiling function', :if => Puppet::Util::Package.versioncmp(return_puppet_version, '6.0.0') < 0 do
  describe 'success' do
    pp1 = <<-DOC
      $a = 12.8
      $b = 13
      $o = ceiling($a)
      if $o == $b {
        notify { 'output correct': }
      }
    DOC
    it 'ceilings floats' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
      $a = 7
      $b = 7
      $o = ceiling($a)
      if $o == $b {
        notify { 'output is correct': }
      }
    DOC
    it 'ceilings integers' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output is correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-numbers'
  end
end
