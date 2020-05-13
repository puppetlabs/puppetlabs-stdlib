require 'spec_helper'
require 'puppet/type'
require 'puppet/type/cron'

describe 'cron_provider', :type => :fact do
  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  subject { Facter.fact(:cron_provider) }

  it { is_expected.not_to be_nil }

  context 'when available' do
    it 'returns crontab' do
      provider = Puppet::Type.type(:cron).provider(:crontab)
      allow(Puppet::Type.type(:cron)).to receive(:defaultprovider).and_return(provider)

      expect(subject.value).to eq('crontab')
    end
  end

  context 'when unavailable' do
    it 'returns nil' do
      allow(Puppet::Type.type(:cron)).to receive(:defaultprovider).and_return(nil)

      expect(subject.value).to be_nil
    end
  end
end
