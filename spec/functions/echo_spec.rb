require 'spec_helper'

describe 'echo' do
  describe 'signature validation' do
    it { is_expected.not_to eq(nil) }
    it { is_expected.to run.with_params().and_raise_error(/wrong number of arguments/i) }
  end
end
