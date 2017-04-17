require 'spec_helper'

describe 'parents' do

  context 'Checking parameter validity' do
    it { is_expected.not_to eq(nil) }
    it do
      is_expected.to run.with_params.and_raise_error(ArgumentError, /Wrong number of arguments/)
    end
    it do
      is_expected.to run.with_params('one', 'two').and_raise_error(ArgumentError, /Wrong number of arguments/)
    end
    it do
      is_expected.to run.with_params([]).and_raise_error(Puppet::ParseError)
    end
    it do
      is_expected.to run.with_params({}).and_raise_error(Puppet::ParseError)
    end
    it do
      is_expected.to run.with_params(1).and_raise_error(Puppet::ParseError)
    end
    it do
      is_expected.to run.with_params('../var/tmp/ssl').and_raise_error(Puppet::ParseError)
    end
  end

  context 'Running with Unix style pathname' do
    sample_text    = '/var/lib/puppet/facts.d'
    desired_output = [
      '/var',
      '/var/lib',
      '/var/lib/puppet',
    ]

    it 'should return correct array' do
      should run.with_params(sample_text).and_return(desired_output)
    end
  end

  context 'Running with Windows style pathname' do
    sample_text    = 'C:\ProgramData\PuppetLabs\puppet\etc'
    desired_output = [
      'C:\ProgramData',
      'C:\ProgramData\PuppetLabs',
      'C:\ProgramData\PuppetLabs\puppet',
    ]

    it 'should return correct array' do
      should run.with_params(sample_text).and_return(desired_output)
    end
  end
end
