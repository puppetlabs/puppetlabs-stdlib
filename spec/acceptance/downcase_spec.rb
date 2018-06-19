require 'spec_helper_acceptance'

describe 'downcase function', :if => Puppet::Util::Package.versioncmp(return_puppet_version, '6.0.0') < 0 do
  describe 'success' do
    pp1 = <<-DOC
      $a = 'AOEU'
      $b = 'aoeu'
      $o = downcase($a)
      if $o == $b {
        notify { 'output correct': }
      }
    DOC
    it 'returns the downcase' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end

    pp2 = <<-DOC
      $a = 'aoeu aoeu'
      $b = 'aoeu aoeu'
      $o = downcase($a)
      if $o == $b {
        notify { 'output correct': }
      }
    DOC
    it 'doesn\'t affect lowercase words' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
  end
  describe 'failure' do
    it 'handles improper argument counts'
    it 'handles non-strings'
  end
end
