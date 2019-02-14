require 'spec_helper'
if Puppet::Util::Package.versioncmp(Puppet.version, '6.0.0') < 0
  describe 'abs' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params(-34).and_return(34) }
    it { is_expected.to run.with_params('-34').and_return(34) }
    it { is_expected.to run.with_params(34).and_return(34) }
    it { is_expected.to run.with_params('34').and_return(34) }
    it { is_expected.to run.with_params(-34.5).and_return(34.5) }
    it { is_expected.to run.with_params('-34.5').and_return(34.5) }
    it { is_expected.to run.with_params(34.5).and_return(34.5) }
    it { is_expected.to run.with_params('34.5').and_return(34.5) }
  end
end
