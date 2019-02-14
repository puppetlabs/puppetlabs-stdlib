require 'spec_helper'

describe 'os_version_gte' do
  context 'on Debian 9' do
    let(:facts) do
      {
        :operatingsystem => 'Debian',
        :operatingsystemmajrelease => '9',
      }
    end

    it { is_expected.to run.with_params('Debian', '9').and_return(true) }
    it { is_expected.to run.with_params('Debian', '8').and_return(false) }
    it { is_expected.to run.with_params('Debian', '8.0').and_return(false) }
    it { is_expected.to run.with_params('Ubuntu', '16.04').and_return(false) }
    it { is_expected.to run.with_params('Fedora', '29').and_return(false) }
  end

  context 'on Ubuntu 16.04' do
    let(:facts) do
      {
        :operatingsystem => 'Ubuntu',
        :operatingsystemmajrelease => '16.04',
      }
    end

    it { is_expected.to run.with_params('Debian', '9').and_return(false) }
    it { is_expected.to run.with_params('Ubuntu', '16').and_return(false) }
    it { is_expected.to run.with_params('Ubuntu', '16.04').and_return(true) }
    it { is_expected.to run.with_params('Ubuntu', '18.04').and_return(true) }
    it { is_expected.to run.with_params('Fedora', '29').and_return(false) }
  end

  context 'with invalid params' do
    let(:facts) do
      {
        :operatingsystem => 'Ubuntu',
        :operatingsystemmajrelease => '16.04',
      }
    end

    it { is_expected.to run.with_params('123', 'abc').and_return(false) }
    it { is_expected.to run.with_params([], 123).and_raise_error(ArgumentError) }
  end
end
