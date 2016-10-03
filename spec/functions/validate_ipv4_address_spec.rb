require 'spec_helper'

describe 'validate_ipv4_address' do

  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }
  end

  context 'Checking for deprecation warning', if: Puppet.version.to_f < 4.0 do
    after(:all) do
      ENV.delete('STDLIB_LOG_DEPRECATIONS')
    end
    # Checking for deprecation warning, which should only be provoked when the env variable for it is set.
    it 'should display a single deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = "true"
      scope.expects(:warning).with(includes('This method is deprecated'))
      is_expected.to run.with_params('1.2.3.4')
    end
    it 'should display no warning for deprecation' do
      ENV['STDLIB_LOG_DEPRECATIONS'] = "false"
      scope.expects(:warning).with(includes('This method is deprecated')).never
      is_expected.to run.with_params('1.2.3.4')
    end
  end 

  describe 'valid inputs' do
    it { is_expected.to run.with_params('0.0.0.0') }
    it { is_expected.to run.with_params('8.8.8.8') }
    it { is_expected.to run.with_params('127.0.0.1') }
    it { is_expected.to run.with_params('10.10.10.10') }
    it { is_expected.to run.with_params('194.232.104.150') }
    it { is_expected.to run.with_params('244.24.24.24') }
    it { is_expected.to run.with_params('255.255.255.255') }
    it { is_expected.to run.with_params('1.2.3.4', '5.6.7.8') }
    context 'with netmasks' do
      it { is_expected.to run.with_params('8.8.8.8/0') }
      it { is_expected.to run.with_params('8.8.8.8/16') }
      it { is_expected.to run.with_params('8.8.8.8/32') }
      it { is_expected.to run.with_params('8.8.8.8/255.255.0.0') }
    end
  end

  describe 'invalid inputs' do
    it { is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError, /is not a string/) }
    it { is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError, /is not a string/) }
    it { is_expected.to run.with_params(true).and_raise_error(Puppet::ParseError, /is not a string/) }
    it { is_expected.to run.with_params('one').and_raise_error(Puppet::ParseError, /is not a valid IPv4/) }
    it { is_expected.to run.with_params('0.0.0').and_raise_error(Puppet::ParseError, /is not a valid IPv4/) }
    it { is_expected.to run.with_params('0.0.0.256').and_raise_error(Puppet::ParseError, /is not a valid IPv4/) }
    it { is_expected.to run.with_params('0.0.0.0.0').and_raise_error(Puppet::ParseError, /is not a valid IPv4/) }
    it { is_expected.to run.with_params('affe::beef').and_raise_error(Puppet::ParseError, /is not a valid IPv4/) }
    it { is_expected.to run.with_params('1.2.3.4', {}).and_raise_error(Puppet::ParseError, /is not a string/) }
    it { is_expected.to run.with_params('1.2.3.4', 1).and_raise_error(Puppet::ParseError, /is not a string/) }
    it { is_expected.to run.with_params('1.2.3.4', true).and_raise_error(Puppet::ParseError, /is not a string/) }
    it { is_expected.to run.with_params('1.2.3.4', 'one').and_raise_error(Puppet::ParseError, /is not a valid IPv4/) }
  end
end
