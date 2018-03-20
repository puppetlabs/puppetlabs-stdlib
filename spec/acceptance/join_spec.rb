require 'spec_helper_acceptance'

describe 'join function', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  describe 'success' do
    pp = <<-DOC
      $a = ['aaa','bbb','ccc']
      $b = ':'
      $c = 'aaa:bbb:ccc'
      $o = join($a,$b)
      if $o == $c {
        notify { 'output correct': }
      }
    DOC
    it 'joins arrays' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: output correct})
      end
    end
    it 'handles non arrays'
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
