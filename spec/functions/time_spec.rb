require 'spec_helper'

describe 'time' do
  it { is_expected.not_to eq(nil) }
  it { is_expected.to run.with_params('a', '').and_raise_error(Puppet::ParseError, /wrong number of arguments/i) }

  context 'when running at a specific time' do
    before(:each) {
      # get a value before stubbing the function
      test_time = Time.utc(2006, 10, 13, 8, 15, 11, '+01:00')
      Time.expects(:new).with().returns(test_time).once
    }
    it { is_expected.to run.with_params().and_return(1160727311) }
    it { is_expected.to run.with_params('').and_return(1160727311) }
    it { is_expected.to run.with_params([]).and_return(1160727311) }
    it { is_expected.to run.with_params({}).and_return(1160727311) }
    it { is_expected.to run.with_params('foo').and_return(1160727311) }
    it { is_expected.to run.with_params('UTC').and_return(1160727311) }

    context 'when running on modern rubies', :unless => RUBY_VERSION == '1.8.7' do
      it { is_expected.to run.with_params('America/Los_Angeles').and_return(1160727311) }
    end

    context 'when running on ruby 1.8.7, which garbles the TZ', :if => RUBY_VERSION == '1.8.7' do
      it { is_expected.to run.with_params('America/Los_Angeles').and_return(1160702111) }
    end
  end
end
