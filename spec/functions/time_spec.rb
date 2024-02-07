# frozen_string_literal: true

require 'spec_helper'

describe 'time' do
  it { is_expected.not_to be_nil }

  context 'when running at a specific time' do
    before(:each) do
      # get a value before stubbing the function
      test_time = Time.utc(2006, 10, 13, 8, 15, 11)
      allow(Time).to receive(:now).and_return(test_time)
    end

    it { is_expected.to run.with_params.and_return(1_160_727_311) }
    it { is_expected.to run.with_params('').and_return(1_160_727_311) }

    describe('Timezone is irrelevant') do
      it { is_expected.to run.with_params('UTC').and_return(1_160_727_311) }
      it { is_expected.to run.with_params('America/New_York').and_return(1_160_727_311) }
    end
  end
end
