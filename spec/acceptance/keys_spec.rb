require 'spec_helper_acceptance'

describe 'keys function', :if => Puppet::Util::Package.versioncmp(Puppet.version, '5.5.0') < 0 do
  describe 'success' do
    pp = <<-DOC
      $a = {'aaa'=>'bbb','ccc'=>'ddd'}
      $o = keys($a)
      notice(inline_template('keys is <%= @o.sort.inspect %>'))
    DOC
    it 'keyss hashes' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{keys is \["aaa", "ccc"\]})
      end
    end
    it 'handles non hashes'
    it 'handles empty hashes'
  end
  describe 'failure' do
    it 'handles improper argument counts'
  end
end
