require 'spec_helper'

describe 'stdlib::round' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params(34.3).and_return(34) }
  it { is_expected.to run.with_params(-34.3).and_return(-34) }
  it { is_expected.to run.with_params(34.5).and_return(35) }
  it { is_expected.to run.with_params(-34.5).and_return(-35) }
  it { is_expected.to run.with_params(34.7).and_return(35) }
  it { is_expected.to run.with_params(-34.7).and_return(-35) }
end
