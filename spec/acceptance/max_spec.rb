require 'spec_helper_acceptance'

describe 'max function', :if => Puppet::Util::Package.versioncmp(return_puppet_version, '6.0.0') < 0 do
  describe 'success' do
    pp = <<-DOC
      $o = max("the","public","art","galleries")
      notice(inline_template('max is <%= @o.inspect %>'))
    DOC
    it 'maxs arrays' do
      apply_manifest(pp, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{max is "the"})
      end
    end
  end
  describe 'failure' do
    it 'handles no arguments'
  end
end
