require 'spec_helper_acceptance'

describe 'defined_with_params function' do
  describe 'success' do
    pp1 = <<-DOC
      user { 'dan':
        ensure => present,
      }

      if defined_with_params(User[dan], {'ensure' => 'present' }) {
        notify { 'User defined with ensure=>present': }
      }
    DOC
    it 'successfullies checks a type' do
      apply_manifest(pp1, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: User defined with ensure=>present})
      end
    end

    pp2 = <<-DOC
      class foo (
        $bar,
      ) {}

      class { 'foo':
        bar => 'baz',
      }

      if defined_with_params(Class[foo], { 'bar' => 'baz' }) {
        notify { 'Class foo defined with bar=>baz': }
      }
    DOC
    it 'successfullies checks a class' do
      apply_manifest(pp2, :catch_failures => true) do |r|
        expect(r.stdout).to match(%r{Notice: Class foo defined with bar=>baz})
      end
    end
  end
end
