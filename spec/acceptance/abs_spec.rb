require 'spec_helper_acceptance'

describe 'abs function', :if => Puppet::Util::Package.versioncmp(return_puppet_version, '6.0.0') < 0 do
  describe 'success' do
    pp1 = <<-DOC
      $input  = '-34.56'
      $output = abs($input)
      notify { "$output": }
    DOC
    it 'accepts a string' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: 34.56})
      end
    end

    pp2 = <<-DOC
      $input  = -35.46
      $output = abs($input)
      notify { "$output": }
    DOC
    it 'accepts a float' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: 35.46})
      end
    end
  end
end
