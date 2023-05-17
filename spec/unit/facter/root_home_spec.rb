# frozen_string_literal: true

require 'spec_helper'
require 'facter/root_home'

describe 'root_home', type: :fact do
  subject { Facter.fact(:root_home) }

  before(:each) { Facter.clear }
  after(:each) { Facter.clear }

  context 'when Windows', if: Facter.value(:kernel) == 'Windows' do
    it { expect(subject.value).to be_nil }
  end

  context 'when non-Windows', if: Facter.value(:kernel) != 'Windows' do
    let(:expected) { (Facter.value(:kernel) == 'Darwin') ? '/var/root' : '/root' }

    it { expect(subject.value).to eq(expected) }
  end
end
