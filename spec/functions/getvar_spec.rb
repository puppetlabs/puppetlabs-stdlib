require 'spec_helper'

describe 'getvar' do
  it { is_expected.not_to eq(nil) }

  describe 'before Puppet 6.0.0', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0 do
    it { is_expected.to run.with_params.and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
    it { is_expected.to run.with_params('one', 'two').and_raise_error(Puppet::ParseError, %r{wrong number of arguments}i) }
  end

  describe 'from Puppet 6.0.0', :if => Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') >= 0 do
    it { is_expected.to run.with_params.and_raise_error(ArgumentError, %r{expects between 1 and 2 arguments, got none}i) }
    it { is_expected.to run.with_params('one', 'two').and_return('two') }
    it { is_expected.to run.with_params('one', 'two', 'three').and_raise_error(ArgumentError, %r{expects between 1 and 2 arguments, got 3}i) }
  end

  it { is_expected.to run.with_params('::foo').and_return(nil) }

  context 'with given variables in namespaces' do
    let(:pre_condition) do
      <<-PUPPETCODE
      class site::data { $foo = 'baz' }
      include site::data
      PUPPETCODE
    end

    it { is_expected.to run.with_params('site::data::foo').and_return('baz') }
    it { is_expected.to run.with_params('::site::data::foo').and_return('baz') }
    it { is_expected.to run.with_params('::site::data::bar').and_return(nil) }
  end

  context 'with given variables in namespaces' do
    let(:pre_condition) do
      <<-PUPPETCODE
      class site::info { $lock = 'ŧҺîš íš ắ śţřĭŋĝ' }
      class site::new { $item = '万Ü€‰' }
      include site::info
      include site::new
      PUPPETCODE
    end

    it { is_expected.to run.with_params('site::info::lock').and_return('ŧҺîš íš ắ śţřĭŋĝ') }
    it { is_expected.to run.with_params('::site::new::item').and_return('万Ü€‰') }
  end
end
